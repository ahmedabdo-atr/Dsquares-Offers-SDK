//
//  OfferCardView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import SwiftUI

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
                
                // Overlay for "locked" status if needed (mocked based on Figma)
                if offer.id % 2 == 0 { // Just as a mock for the demo
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            .frame(height: 120)
            .cornerRadius(8, corners: [.topLeft, .topRight])
            
            // Info Section
            VStack(alignment: .leading, spacing: 4) {
                Text(offer.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DSColor.textPrimary)
                    .lineLimit(1)
                
                Text(offer.merchantName ?? "Merchent Name")
                    .font(.system(size: 12))
                    .foregroundColor(DSColor.textSecondary)
                
                HStack(spacing: 2) {
                    Text("من") // From (Arabic)
                        .font(.system(size: 10))
                        .foregroundColor(DSColor.textSecondary)
                    
                    Text("\(offer.points ?? "5,000") نقطة") // XXX points
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(DSColor.textPrimary)
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(DSColor.background)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Utility to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
