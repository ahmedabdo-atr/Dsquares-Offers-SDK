//
//  OffersNetworkService.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
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
        
        let body = LoginRequestDTO(userIdentifier: userIdentifier)
        do {
            request.httpBody = try JSONEncoder().encode(body)
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
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
    
    public func fetchOffers(page: Int) async throws -> OffersResponseDTO {
        guard let token = self.accessToken else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/api/DynamicApp/v1/Integration/Items") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let body = ItemsRequestDTO(page: page, pageSize: 10)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.decodingFailed
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        if httpResponse.statusCode == 200 {
            do {
                let itemsResponse = try JSONDecoder().decode(ItemsResponseDTO.self, from: data)
                let legacyOffers = itemsResponse.result?.items.map { item -> OfferDTO in
                    let domainOffer = item.toDomain()
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
                
                return OffersResponseDTO(
                    data: legacyOffers,
                    totalCount: itemsResponse.result?.totalItems,
                    currentPage: page,
                    totalPages: itemsResponse.result?.totalPages
                )
            } catch {
                throw NetworkError.decodingFailed
            }
        } else {
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
}
