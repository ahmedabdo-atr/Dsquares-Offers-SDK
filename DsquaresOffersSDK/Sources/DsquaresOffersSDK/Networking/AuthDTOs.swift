//
//  AuthDTOs.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

/// Request body for the Token API
public struct LoginRequestDTO: Encodable {
    public let data: LoginData
    
    public init(userIdentifier: String) {
        self.data = LoginData(userIdentifier: userIdentifier)
    }
}

public struct LoginData: Encodable {
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
    public let referenceCode: String?
    public let errors: [String]?
    
    public init(result: TokenResultDTO?, message: String?, statusCode: Int, statusName: String?, referenceCode: String? = nil, errors: [String]? = nil) {
        self.result = result
        self.message = message
        self.statusCode = statusCode
        self.statusName = statusName
        self.referenceCode = referenceCode
        self.errors = errors
    }
    
    enum CodingKeys: String, CodingKey {
        case result
        case message
        case statusCode = "statusCode"
        case statusName = "statusName"
        case referenceCode = "referenceCode"
        case errors = "errors"
    }
}

public struct TokenResultDTO: Codable {
    public let tokenType: String?
    public let accessToken: String?
    public let expiresInMins: Int?
    public let refreshToken: String?
    
    public init(tokenType: String?, accessToken: String?, expiresInMins: Int?, refreshToken: String?) {
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.expiresInMins = expiresInMins
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "tokenType"
        case accessToken = "accessToken"
        case expiresInMins = "expiresInMins"
        case refreshToken = "refreshToken"
    }
}
