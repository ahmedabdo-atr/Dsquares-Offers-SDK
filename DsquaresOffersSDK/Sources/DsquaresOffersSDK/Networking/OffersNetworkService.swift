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
        print("🚀 [OffersSDK] Starting login request for: \(userIdentifier)")
        
        guard let url = URL(string: "\(baseURL)/api/DynamicApp/v1/Integration/Token") else {
            print("❌ [OffersSDK] Invalid login URL")
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Exact headers used in the successful manual test (Apidog)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // Using the updated DTO which wraps the identifier in a "data" object as required
        let body = LoginRequestDTO(userIdentifier: userIdentifier)
        do {
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
            if let bodyString = String(data: encodedBody, encoding: .utf8) {
                print("📤 [OffersSDK] Login Body: \(bodyString)")
            }
        } catch {
            print("❌ [OffersSDK] Encoding failed")
            throw NetworkError.decodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [OffersSDK] Failed to get HTTPURLResponse")
            throw NetworkError.requestFailed
        }
        
        print("📥 [OffersSDK] Login Status Code: \(httpResponse.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 [OffersSDK] Login Response Body: \(responseString)")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
                
                if let token = decodedResponse.result?.accessToken {
                    print("✅ [OffersSDK] Login success. Token acquired.")
                    self.accessToken = token
                }
                
                return decodedResponse
            } catch {
                print("❌ [OffersSDK] Login decoding failed: \(error)")
                throw NetworkError.decodingFailed
            }
        case 401:
            print("❌ [OffersSDK] Unauthorized")
            throw NetworkError.unauthorized
        case 403:
            print("❌ [OffersSDK] Forbidden")
            throw NetworkError.forbidden
        default:
            print("❌ [OffersSDK] Server returned: \(httpResponse.statusCode)")
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
    
    public func fetchOffers(page: Int) async throws -> OffersResponseDTO {
        print("🚀 [OffersSDK] Fetching offers page: \(page)")
        
        guard let url = URL(string: "\(baseURL)/?page=\(page)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ [OffersSDK] No token found, using API Key for auth")
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.requestFailed
            }
            
            print("📥 [OffersSDK] FetchOffers Status Code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                let decoded = try JSONDecoder().decode(OffersResponseDTO.self, from: data)
                print("✅ [OffersSDK] Fetched \(decoded.data.count) offers")
                return decoded
            case 401:
                print("❌ [OffersSDK] Offers Unauthorized")
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.invalidResponse(httpResponse.statusCode)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            print("❌ [OffersSDK] FetchOffers failed: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}
