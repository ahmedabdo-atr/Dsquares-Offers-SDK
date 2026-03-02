//
//  OffersNetworkService.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

public protocol OffersNetworkServiceProtocol {
    func fetchOffers(page: Int) async throws -> OffersResponseDTO
}

public class OffersNetworkService: OffersNetworkServiceProtocol {
    
    private let baseURL = "https://connect-api.dsquares.com/"
    
    public init() {}
    
    public func fetchOffers(page: Int) async throws -> OffersResponseDTO {
            guard let url = URL(string: "\(baseURL)?page=\(page)") else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let apiKey = "H9eAm0I3lDZX8XtjwjYBkVJe2Mb0TTeB"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
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
