import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct OfferCardView: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .topTrailing) {
                if let url = offer.imageUrl {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 120)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .frame(height: 120)
                                .background(DSColor.secondaryBackground)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .fill(DSColor.secondaryBackground)
                        .frame(height: 120)
                }
            }
            .frame(height: 120)
            .cornerRadius(8) // Simplified for cross-platform compatibility
            
            // Info Section
            VStack(alignment: .leading, spacing: 4) {
                Text(offer.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DSColor.textPrimary)
                    .lineLimit(1)
                
                Text(offer.merchantName ?? "Merchant")
                    .font(.system(size: 12))
                    .foregroundColor(DSColor.textSecondary)
                
                HStack(spacing: 2) {
                    Text("\(offer.points ?? "0") pts")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(DSColor.textPrimary)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(DSColor.background)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
