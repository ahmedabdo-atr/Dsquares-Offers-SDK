import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct OfferCardView: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section with badges
            ZStack(alignment: .topTrailing) {
                imageSection
                
                // Reward Type Badge
                if let rewardType = offer.rewardType {
                    Text(rewardType)
                        .font(DSTypography.small())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DSColor.primary)
                        .cornerRadius(6)
                        .padding(8)
                }
                
                // Locked State Overlay
                if offer.isLocked {
                    ZStack {
                        Color.black.opacity(0.4)
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
            }
            .frame(height: 140)
            .clipped()
            
            // Info Section
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(offer.merchantName ?? "Merchant")
                        .font(DSTypography.caption())
                        .foregroundColor(DSColor.textSecondary)
                        .textCase(.uppercase)
                    
                    Text(offer.title)
                        .font(DSTypography.subtitle())
                        .foregroundColor(DSColor.textPrimary)
                        .lineLimit(2)
                        .frame(height: 40, alignment: .topLeading)
                }
                
                Spacer(minLength: 8)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(DSColor.accent)
                        Text(offer.points ?? "0")
                            .font(DSTypography.body().bold())
                            .foregroundColor(DSColor.textPrimary)
                        Text("pts")
                            .font(DSTypography.caption())
                            .foregroundColor(DSColor.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(DSColor.primary)
                        .padding(6)
                        .background(DSColor.primary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(12)
        }
        .background(DSColor.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DSColor.border, lineWidth: 1)
        )
        .scaleEffect(offer.isLocked ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: offer.isLocked)
    }
    
    @ViewBuilder
    private var imageSection: some View {
        if let url = offer.imageUrl {
            let _ = print("🖼️ [OfferCardView] Loading image from: \(url.absoluteString)")
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(DSColor.secondaryBackground)
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ZStack {
                        Rectangle().fill(DSColor.secondaryBackground)
                        Image(systemName: "photo")
                            .foregroundColor(DSColor.textSecondary)
                    }
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Rectangle()
                .fill(DSColor.secondaryBackground)
        }
    }
}
