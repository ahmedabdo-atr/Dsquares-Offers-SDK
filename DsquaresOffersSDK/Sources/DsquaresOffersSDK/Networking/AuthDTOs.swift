//
//  AuthDTOs.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

/// Request body for the Token API
public struct LoginRequestDTO: Encodable {
    public let userIdentifier: String
    
    enum CodingKeys: String, CodingKey {
        case userIdentifier = "UserIdentifier"
    }
}

/// Response data for the Token API
public struct LoginResponseDTO: Decodable {
    public let result: TokenResultDTO?
    public let message: String?
    public let statusCode: Int
    public let statusName: String?
}

public struct TokenResultDTO: Decodable {
    public let tokenType: String?
    public let accessToken: String?
    public let expiresInMins: Int?
    public let refreshToken: String?
}
