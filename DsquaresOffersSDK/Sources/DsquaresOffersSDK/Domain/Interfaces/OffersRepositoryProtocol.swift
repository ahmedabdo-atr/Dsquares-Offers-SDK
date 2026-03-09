//
//  OffersRepositoryProtocol.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
//

import Foundation

public protocol OffersRepositoryProtocol: Sendable {
    func getOffers(page: Int) async throws -> [Offer]
}
