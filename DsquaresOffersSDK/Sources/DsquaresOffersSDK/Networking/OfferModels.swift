//
//  OfferModels.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

// Offer model representing each offer returned from the API
public struct Offer: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let description: String?
    public let imageUrl: String?
}

// OffersResponse model representing the API response containing offers and pagination info
public struct OffersResponse: Codable {
    public let data: [Offer]
    public let totalPages: Int? 
}
