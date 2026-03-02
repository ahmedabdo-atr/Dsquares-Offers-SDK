//
//  NetworkError.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse(Int) // Handle status codes
    case decodingFailed
    case offline
    case unauthorized
    case forbidden
    case serverError
    
    public var customMessage: String {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .requestFailed: return "The network request failed."
        case .invalidResponse(let code): return "Server returned an error: \(code)."
        case .decodingFailed: return "Failed to decode the data from server."
        case .offline: return "No internet connection. Please check your network."
        case .unauthorized: return "Unauthorized: Please check your API key."
        case .forbidden: return "Forbidden: Your IP might not be whitelisted."
        case .serverError: return "Server error. Please try again later."
        }
    }
}
