//
//  OfferRowView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import SwiftUI

struct OfferRowView: View {
    let offer: Offer
    
    var body: some View {
        HStack(spacing: 12) {
            // swiftui 15 introduced AsyncImage which simplifies loading images from URLs with built-in caching and error handling.
            AsyncImage(url: offer.imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    // Show a placeholder image on failure
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(offer.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let desc = offer.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
