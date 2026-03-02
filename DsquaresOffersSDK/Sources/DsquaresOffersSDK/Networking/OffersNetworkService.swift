//
//  OffersNetworkService.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

public protocol OffersNetworkServiceProtocol: Sendable {
    func login(userIdentifier: String) async throws -> LoginResponseDTO
    func fetchOffers(page: Int) async throws -> OffersResponseDTO
}

public final class OffersNetworkService: OffersNetworkServiceProtocol {
    
    private let baseURL = "https://connect-api.dsquares.com"
    private let apiKey = "H9eAm0I3lDZX8XtjwjYBkVJe2Mb0TTeB"
    
    // In a real app, this should be in a secure storage like Keychain
    private var accessToken: String?
    
    public init() {}
    
    public func login(userIdentifier: String) async throws -> LoginResponseDTO {
        guard let url = URL(string: "\(baseURL)/api/DynamicApp/v1/Integration/Token") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(Locale.current.languageCode ?? "en", forHTTPHeaderField: "Accept-Language")
        
        let body = LoginRequestDTO(userIdentifier: userIdentifier)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decodedResponse = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
        
        // Save the token for subsequent requests
        if let token = decodedResponse.result?.accessToken {
            self.accessToken = token
        }
        
        return decodedResponse
    }
    
    public func fetchOffers(page: Int) async throws -> OffersResponseDTO {
        // Updated endpoint potentially? The previous one was just the base URL with query params.
        // Assuming the base offers API still works similarly but might need the JWT now.
        guard let url = URL(string: "\(baseURL)/?page=\(page)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // If we have an access token, we use it. Otherwise fallback to API Key or specific logic.
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decodedResponse = try JSONDecoder().decode(OffersResponseDTO.self, from: data)
            return decodedResponse
            
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw NetworkError.offline
            } else {
                throw NetworkError.requestFailed
            }
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
