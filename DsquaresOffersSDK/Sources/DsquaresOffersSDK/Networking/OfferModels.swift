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
    public let brandName: String?
    public let brandLogo: String?
    public let expiryDate: String?
    
    public init(id: Int, title: String, description: String?, imageUrl: String?, brandName: String?, brandLogo: String?, expiryDate: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.brandName = brandName
        self.brandLogo = brandLogo
        self.expiryDate = expiryDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case imageUrl = "image_url"
        case brandName = "brand_name"
        case brandLogo = "brand_logo"
        case expiryDate = "expiry_date"
    }
    
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
    public let totalCount: Int?
    public let currentPage: Int?
    public let totalPages: Int?
    
    public init(data: [OfferDTO], totalCount: Int?, currentPage: Int?, totalPages: Int?) {
        self.data = data
        self.totalCount = totalCount
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}
