//
//  ItemsDTO.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 08/03/2026.
//

import Foundation

/// Request body for the Items API
public struct ItemsRequestDTO: Encodable {
    public let data: ItemsRequestData
    
    public init(page: Int = 1, pageSize: Int = 10, name: String = "", categoryCode: String = "", rewardTypes: [String] = ["GiftCards", "Discounts"]) {
        self.data = ItemsRequestData(
            page: page,
            pageSize: pageSize,
            name: name,
            categoryCode: categoryCode,
            rewardTypes: rewardTypes
        )
    }
}

public struct ItemsRequestData: Encodable {
    public let page: Int
    public let pageSize: Int
    public let name: String
    public let categoryCode: String
    public let rewardTypes: [String]
}

/// Response data for the Items API
public struct ItemsResponseDTO: Codable {
    public let result: ItemsResult?
    public let message: String?
    public let statusCode: Int
    public let statusName: String?
    
    enum CodingKeys: String, CodingKey {
        case result, message, statusCode, statusName
    }
}

public struct ItemsResult: Codable {
    public let totalItems: Int
    public let totalPages: Int
    public let items: [ItemDTO]
}

public struct ItemDTO: Codable {
    public let code: String
    public let name: String
    public let description: String?
    public let imageUrl: String?
    public let rewardType: String?
    public let locked: Bool
    public let denominations: [DenominationDTO]?
    
    // Mapping to Domain Entity
    func toDomain() -> Offer {
        // Find the "best" denomination to show (e.g., the first one)
        let firstDenom = denominations?.first
        
        return Offer(
            id: Int(code.replacingOccurrences(of: "b-", with: "")) ?? 0, // Fallback conversion
            title: name,
            description: description,
            imageUrl: URL(string: imageUrl ?? ""),
            points: "\(firstDenom?.points ?? 0)",
            merchantName: firstDenom?.brand
        )
    }
}

public struct DenominationDTO: Codable {
    public let brand: String?
    public let code: String?
    public let name: String?
    public let value: Double?
    public let categories: [String]?
    public let inStock: Bool?
    public let termsAndConditions: String?
    public let usageInstructions: String?
    public let from: Double?
    public let to: Double?
    public let description: String?
    public let denominationType: String?
    public let redemptionChannel: String?
    public let imageUrl: String?
    public let redemptionFactor: Double?
    public let points: Int?
    public let discount: String?
}
