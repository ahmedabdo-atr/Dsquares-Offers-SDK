//
//  ItemsDTO.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
//

import Foundation

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

public struct ItemsResponseDTO: Codable {
    public let result: ItemsResult?
    public let message: String?
    public let statusCode: Int
    public let statusName: String?
    
    enum CodingKeys: String, CodingKey {
        case result, data, Data, Result, Message, StatusCode, StatusName
        case message, statusCode, statusName
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var decodedResult: ItemsResult? = try? container.decodeIfPresent(ItemsResult.self, forKey: .result)
        if decodedResult == nil { decodedResult = try? container.decodeIfPresent(ItemsResult.self, forKey: .data) }
        if decodedResult == nil { decodedResult = try? container.decodeIfPresent(ItemsResult.self, forKey: .Data) }
        if decodedResult == nil { decodedResult = try? container.decodeIfPresent(ItemsResult.self, forKey: .Result) }
        result = decodedResult
        
        message = (try? container.decodeIfPresent(String.self, forKey: .message)) ?? (try? container.decodeIfPresent(String.self, forKey: .Message))
        statusCode = try (container.decodeIfPresent(Int.self, forKey: .statusCode) ?? container.decode(Int.self, forKey: .StatusCode))
        statusName = (try? container.decodeIfPresent(String.self, forKey: .statusName)) ?? (try? container.decodeIfPresent(String.self, forKey: .StatusName))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(message, forKey: .message)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encode(statusName, forKey: .statusName)
    }
}

public struct ItemsResult: Codable {
    public let totalItems: Int
    public let totalPages: Int
    public let items: [ItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalItems, totalPages, items
        case TotalItems, TotalPages, Items
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalItems = try (container.decodeIfPresent(Int.self, forKey: .totalItems) ?? container.decode(Int.self, forKey: .TotalItems))
        totalPages = try (container.decodeIfPresent(Int.self, forKey: .totalPages) ?? container.decode(Int.self, forKey: .TotalPages))
        items = try (container.decodeIfPresent([ItemDTO].self, forKey: .items) ?? container.decode([ItemDTO].self, forKey: .Items))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalItems, forKey: .totalItems)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(items, forKey: .items)
    }
}

public struct ItemDTO: Codable {
    public let code: String
    public let name: String
    public let description: String?
    public let imageUrl: String?
    public let rewardType: String?
    public let locked: Bool
    public let denominations: [DenominationDTO]?
    
    public init(code: String, name: String, description: String?, imageUrl: String?, rewardType: String?, locked: Bool, denominations: [DenominationDTO]?) {
        self.code = code
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.rewardType = rewardType
        self.locked = locked
        self.denominations = denominations
    }
    
    enum CodingKeys: String, CodingKey {
        case code, name, description, locked, rewardType, denominations, imageUrl
        case image_url, ImageUrl, RewardType, Locked, Code, Name, Description
        case brand, Brand, Logo, logo, BrandLogo, brand_logo
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedCode = (try? container.decode(String.self, forKey: .code)) ?? 
                         (try? container.decode(String.self, forKey: .Code))
        code = decodedCode ?? ""
        
        var decodedName: String? = try? container.decode(String.self, forKey: .name)
        if decodedName == nil { decodedName = try? container.decode(String.self, forKey: .Name) }
        if decodedName == nil { decodedName = try? container.decode(String.self, forKey: .brand) }
        if decodedName == nil { decodedName = try? container.decode(String.self, forKey: .Brand) }
        name = decodedName ?? "Unknown Item"
               
        description = (try? container.decodeIfPresent(String.self, forKey: .description)) ?? (try? container.decodeIfPresent(String.self, forKey: .Description))
        locked = (try? container.decode(Bool.self, forKey: .locked)) ?? (try? container.decode(Bool.self, forKey: .Locked)) ?? false
        rewardType = (try? container.decodeIfPresent(String.self, forKey: .rewardType)) ?? (try? container.decodeIfPresent(String.self, forKey: .RewardType))
        denominations = try container.decodeIfPresent([DenominationDTO].self, forKey: .denominations)
        
        var rootImg: String? = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        if rootImg == nil { rootImg = try? container.decodeIfPresent(String.self, forKey: .image_url) }
        if rootImg == nil { rootImg = try? container.decodeIfPresent(String.self, forKey: .ImageUrl) }
                      
        var logoImg: String? = try? container.decodeIfPresent(String.self, forKey: .logo)
        if logoImg == nil { logoImg = try? container.decodeIfPresent(String.self, forKey: .Logo) }
        if logoImg == nil { logoImg = try? container.decodeIfPresent(String.self, forKey: .brand_logo) }
        if logoImg == nil { logoImg = try? container.decodeIfPresent(String.self, forKey: .BrandLogo) }
                      
        imageUrl = rootImg ?? logoImg
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(locked, forKey: .locked)
        try container.encode(rewardType, forKey: .rewardType)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(denominations, forKey: .denominations)
    }
    
    func toDomain() -> Offer {
        let firstDenom = denominations?.first
        let rawImageUrl = (imageUrl != nil && !imageUrl!.isEmpty) ? imageUrl : firstDenom?.imageUrl
        let finalImageUrl = fixURL(rawImageUrl)
        
        return Offer(
            id: Int(code.replacingOccurrences(of: "b-", with: "")) ?? 0,
            title: name,
            description: description,
            imageUrl: URL(string: finalImageUrl ?? ""),
            points: "\(firstDenom?.points ?? 0)",
            merchantName: firstDenom?.brand ?? name,
            isLocked: locked,
            rewardType: rewardType
        )
    }
    
    private func fixURL(_ urlString: String?) -> String? {
        guard let urlString = urlString, !urlString.isEmpty else { return nil }
        if urlString.hasPrefix("http") {
            return urlString
        }
        let baseURL = "https://connect-api.dsquares.com"
        if urlString.hasPrefix("/") {
            return baseURL + urlString
        }
        return baseURL + "/" + urlString
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
    
    enum CodingKeys: String, CodingKey {
        case brand, code, name, value, categories, inStock, termsAndConditions, usageInstructions, from, to, description, denominationType, redemptionChannel, imageUrl, redemptionFactor, points, discount
        case image_url, ImageUrl, InStock, Description, Points, Brand, Code, Name, Value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brand = (try? container.decodeIfPresent(String.self, forKey: .brand)) ?? (try? container.decodeIfPresent(String.self, forKey: .Brand))
        code = (try? container.decodeIfPresent(String.self, forKey: .code)) ?? (try? container.decodeIfPresent(String.self, forKey: .Code))
        name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? (try? container.decodeIfPresent(String.self, forKey: .Name))
        value = (try? container.decodeIfPresent(Double.self, forKey: .value)) ?? (try? container.decodeIfPresent(Double.self, forKey: .Value))
        categories = try? container.decodeIfPresent([String].self, forKey: .categories)
        inStock = (try? container.decodeIfPresent(Bool.self, forKey: .inStock)) ?? (try? container.decodeIfPresent(Bool.self, forKey: .InStock))
        termsAndConditions = try? container.decodeIfPresent(String.self, forKey: .termsAndConditions)
        usageInstructions = try? container.decodeIfPresent(String.self, forKey: .usageInstructions)
        from = try? container.decodeIfPresent(Double.self, forKey: .from)
        to = try? container.decodeIfPresent(Double.self, forKey: .to)
        description = (try? container.decodeIfPresent(String.self, forKey: .description)) ?? (try? container.decodeIfPresent(String.self, forKey: .Description))
        denominationType = try? container.decodeIfPresent(String.self, forKey: .denominationType)
        redemptionChannel = try? container.decodeIfPresent(String.self, forKey: .redemptionChannel)
        redemptionFactor = try? container.decodeIfPresent(Double.self, forKey: .redemptionFactor)
        points = (try? container.decodeIfPresent(Int.self, forKey: .points)) ?? (try? container.decodeIfPresent(Int.self, forKey: .Points))
        discount = try? container.decodeIfPresent(String.self, forKey: .discount)
        
        var decodedImageUrl: String? = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        if decodedImageUrl == nil { decodedImageUrl = try? container.decodeIfPresent(String.self, forKey: .image_url) }
        if decodedImageUrl == nil { decodedImageUrl = try? container.decodeIfPresent(String.self, forKey: .ImageUrl) }
        imageUrl = decodedImageUrl
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brand, forKey: .brand)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(categories, forKey: .categories)
        try container.encode(inStock, forKey: .inStock)
        try container.encode(termsAndConditions, forKey: .termsAndConditions)
        try container.encode(usageInstructions, forKey: .usageInstructions)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(description, forKey: .description)
        try container.encode(denominationType, forKey: .denominationType)
        try container.encode(redemptionChannel, forKey: .redemptionChannel)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(redemptionFactor, forKey: .redemptionFactor)
        try container.encode(points, forKey: .points)
        try container.encode(discount, forKey: .discount)
    }

    public init(brand: String?, code: String? = nil, name: String? = nil, value: Double? = nil, categories: [String]? = nil, inStock: Bool? = nil, termsAndConditions: String? = nil, usageInstructions: String? = nil, from: Double? = nil, to: Double? = nil, description: String? = nil, denominationType: String? = nil, redemptionChannel: String? = nil, imageUrl: String? = nil, redemptionFactor: Double? = nil, points: Int? = nil, discount: String? = nil) {
        self.brand = brand
        self.code = code
        self.name = name
        self.value = value
        self.categories = categories
        self.inStock = inStock
        self.termsAndConditions = termsAndConditions
        self.usageInstructions = usageInstructions
        self.from = from
        self.to = to
        self.description = description
        self.denominationType = denominationType
        self.redemptionChannel = redemptionChannel
        self.imageUrl = imageUrl
        self.redemptionFactor = redemptionFactor
        self.points = points
        self.discount = discount
    }
}
