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
public struct LoginResponseDTO: Codable {
    public let result: TokenResultDTO?
    public let message: String?
    public let statusCode: Int
    public let statusName: String?
    
    public init(result: TokenResultDTO?, message: String?, statusCode: Int, statusName: String?) {
        self.result = result
        self.message = message
        self.statusCode = statusCode
        self.statusName = statusName
    }
    
    enum CodingKeys: String, CodingKey {
        case result
        case message
        case statusCode = "status_code"
        case statusName = "status_name"
    }
}

public struct TokenResultDTO: Codable {
    public let tokenType: String?
    public let accessToken: String?
    public let expiresIn: Int?
    public let refreshToken: String?
    
    public init(tokenType: String?, accessToken: String?, expiresIn: Int?, refreshToken: String?) {
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}
