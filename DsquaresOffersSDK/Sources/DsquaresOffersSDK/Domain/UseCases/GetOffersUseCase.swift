//
//  GetOffersUseCase.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

/// Use case to fetch paginated offers.
/// Encapsulates the business logic for retrieving offers.
public protocol GetOffersUseCaseProtocol {
    func execute(page: Int) async throws -> [Offer]
}

public final class GetOffersUseCase: GetOffersUseCaseProtocol {
    private let repository: OffersRepositoryProtocol
    
    public init(repository: OffersRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(page: Int) async throws -> [Offer] {
        return try await repository.getOffers(page: page)
    }
}
