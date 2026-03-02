//
//  OfferDTO.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

// Data Transfer Object representing each offer returned from the API
public struct OfferDTO: Codable {
    public let id: Int
    public let title: String
    public let description: String?
    public let imageUrl: String?
    
    // Mapping to Domain Entity
    func toDomain() -> Offer {
        return Offer(
            id: id,
            title: title,
            description: description,
            imageUrl: URL(string: imageUrl ?? "")
        )
    }
}

// Data Transfer Object representing the API response containing offers and pagination info
public struct OffersResponseDTO: Codable {
    public let data: [OfferDTO]
    public let totalPages: Int?
}
