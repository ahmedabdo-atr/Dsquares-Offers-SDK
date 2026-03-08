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
    
    public static let shared = OffersNetworkService()
    
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
        print("🚀 [OffersSDK] Fetching Items (Offers) page: \(page)")
        
        guard let token = self.accessToken else {
            print("❌ [OffersSDK] No token found for fetchItems")
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/api/DynamicApp/v1/Integration/Items") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Documentation says POST for Items
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // Build the request body as per documentation
        let body = ItemsRequestDTO(page: page, pageSize: 10)
        do {
            request.httpBody = try JSONEncoder().encode(body)
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 [OffersSDK] Items Request Body: \(bodyString)")
            }
        } catch {
            print("❌ [OffersSDK] Failed to encode Items request")
            throw NetworkError.decodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        print("📥 [OffersSDK] Items Status Code: \(httpResponse.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 [OffersSDK] Items Response Body: \(responseString)")
        }
        
        if httpResponse.statusCode == 200 {
            do {
                let itemsResponse = try JSONDecoder().decode(ItemsResponseDTO.self, from: data)
                
                // Map ItemsResponseDTO to the legacy OffersResponseDTO to keep existing logic working
                // Or we can refactor the whole chain, but mapping is safer for now.
                let legacyOffers = itemsResponse.result?.items.map { item -> OfferDTO in
                    let domainOffer = item.toDomain()
                    print("📦 [OffersSDK] Mapped Item: \(item.name), Image: \(domainOffer.imageUrl?.absoluteString ?? "N/A")")
                    return OfferDTO(
                        id: domainOffer.id,
                        title: item.name,
                        description: item.description,
                        imageUrl: domainOffer.imageUrl?.absoluteString,
                        brandName: item.denominations?.first?.brand,
                        brandLogo: nil,
                        expiryDate: nil,
                        isLocked: item.locked,
                        rewardType: item.rewardType,
                        points: "\(item.denominations?.first?.points ?? 0)"
                    )
                } ?? []
                
                print("✅ [OffersSDK] Successfully fetched \(legacyOffers.count) items")
                return OffersResponseDTO(
                    data: legacyOffers,
                    totalCount: itemsResponse.result?.totalItems,
                    currentPage: page,
                    totalPages: itemsResponse.result?.totalPages
                )
            } catch {
                print("❌ [OffersSDK] Items decoding failed: \(error)")
                throw NetworkError.decodingFailed
            }
        } else {
            if let errorMsg = String(data: data, encoding: .utf8) {
                print("❌ [OffersSDK] Items Error Body: \(errorMsg)")
            }
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
}
