//
//  OfferModels.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
//

import Foundation

public struct OfferDTO: Codable {
    public let id: Int
    public let title: String
    public let description: String?
    public let imageUrl: String?
    public let brandName: String?
    public let brandLogo: String?
    public let expiryDate: String?
    public let isLocked: Bool?
    public let rewardType: String?
    public let points: String?
    
    public init(id: Int, title: String, description: String?, imageUrl: String?, brandName: String?, brandLogo: String?, expiryDate: String?, isLocked: Bool? = nil, rewardType: String? = nil, points: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.brandName = brandName
        self.brandLogo = brandLogo
        self.expiryDate = expiryDate
        self.isLocked = isLocked
        self.rewardType = rewardType
        self.points = points
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case imageUrl = "image_url"
        case brandName = "brand_name"
        case brandLogo = "brand_logo"
        case expiryDate = "expiry_date"
        case isLocked = "is_locked"
        case rewardType = "reward_type"
        case points
    }
    
    func toDomain() -> Offer {
        return Offer(
            id: id,
            title: title,
            description: description,
            imageUrl: URL(string: imageUrl ?? ""),
            points: points,
            merchantName: brandName,
            isLocked: isLocked ?? false,
            rewardType: rewardType
        )
    }
}

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
