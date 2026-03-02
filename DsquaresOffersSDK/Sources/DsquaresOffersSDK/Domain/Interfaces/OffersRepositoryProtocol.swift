//
//  OffersRepositoryProtocol.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

/// Protocol defining the contract for fetching offers.
/// Implementation will be in the Data layer.
public protocol OffersRepositoryProtocol: Sendable {
    func getOffers(page: Int) async throws -> [Offer]
}
