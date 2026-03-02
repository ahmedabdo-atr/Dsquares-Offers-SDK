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

public final class OffersNetworkService: OffersNetworkServiceProtocol, @unchecked Sendable {
    
    private let baseURL = "https://connect-api.dsquares.com"
    private let apiKey = "H9eAm0I3lDZX8XtjwjYBkVJe2Mb0TTeB"
    private let lock = NSLock()
    
    // In a real app, this should be in a secure storage like Keychain
    private var _accessToken: String?
    private var accessToken: String? {
        get {
            lock.lock(); defer { lock.unlock() }
            return _accessToken
        }
        set {
            lock.lock(); defer { lock.unlock() }
            _accessToken = newValue
        }
    }
    
    public init() {}
    
    public func login(userIdentifier: String) async throws -> LoginResponseDTO {
        guard let url = URL(string: "\(baseURL)/api/DynamicApp/v1/Integration/Token") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("en", forHTTPHeaderField: "Accept-Language")
        
        // Using Dictionary to ensure the key is exactly as the documentation says
        let parameters: [String: Any] = ["UserIdentifier": userIdentifier]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw NetworkError.decodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
                
                if let token = decodedResponse.result?.accessToken {
                    self.accessToken = token
                }
                
                return decodedResponse
            } catch {
                throw NetworkError.decodingFailed
            }
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        default:
            // This will now show the exact code (like 500)
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.requestFailed
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(OffersResponseDTO.self, from: data)
            case 401:
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.invalidResponse(httpResponse.statusCode)
            }
            
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw NetworkError.offline
            } else {
                throw NetworkError.requestFailed
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
