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
    case invalidResponse
    case decodingFailed
    case offline
    
    public var customMessage: String {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .requestFailed: return "The network request failed."
        case .invalidResponse: return "Invalid response from the server."
        case .decodingFailed: return "Failed to decode the data."
        case .offline: return "No internet connection. Please check your network."
        }
    }
}
