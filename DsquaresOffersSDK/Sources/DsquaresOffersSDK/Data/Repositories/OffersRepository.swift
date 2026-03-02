//
//  OffersRepository.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

public final class OffersRepository: OffersRepositoryProtocol {
    private let networkService: OffersNetworkServiceProtocol
    
    public init(networkService: OffersNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getOffers(page: Int) async throws -> [Offer] {
        let response = try await networkService.fetchOffers(page: page)
        return response.data.map { $0.toDomain() }
    }
}
