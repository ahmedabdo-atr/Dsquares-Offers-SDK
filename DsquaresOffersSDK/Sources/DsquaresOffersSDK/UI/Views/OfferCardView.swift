import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct OfferCardView: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section with better badges
            ZStack(alignment: .topTrailing) {
                imageSection
                
                // Premium Badge
                if let rewardType = offer.rewardType {
                    Text(rewardType)
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(DSColor.primary)
                                .shadow(color: DSColor.primary.opacity(0.4), radius: 5, x: 0, y: 3)
                        )
                        .padding(10)
                }
                
                // Locked State Overlay with Glassmorphism
                if offer.isLocked {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                                .shadow(radius: 5)
                        )
                }
            }
            .frame(height: 150)
            .clipped()
            
            // Info Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(offer.merchantName ?? "Merchant")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(DSColor.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DSColor.primary.opacity(0.1))
                        .cornerRadius(6)
                    
                    Spacer()
                }
                
                Text(offer.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(DSColor.textPrimary)
                    .lineLimit(2)
                    .frame(height: 42, alignment: .topLeading)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("REDEEM FOR")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(DSColor.textSecondary)
                        
                        HStack(spacing: 4) {
                            Text(offer.points ?? "0")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(DSColor.textPrimary)
                            Text("PTS")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(DSColor.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Circle()
                        .fill(DSColor.primary)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: DSColor.primary.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
            .padding(14)
        }
        .background(DSColor.surface)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(DSColor.border.opacity(0.5), lineWidth: 1)
        )
        .scaleEffect(offer.isLocked ? 0.98 : 1.0)
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
