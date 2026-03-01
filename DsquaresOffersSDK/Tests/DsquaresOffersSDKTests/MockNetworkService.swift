//
//  MockNetworkService.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation
@testable import DsquaresOffersSDK // importing the module to access the Protocol and types

//  This is a mock implementation of the OffersNetworkServiceProtocol for testing purposes.
class MockNetworkService: OffersNetworkServiceProtocol {
    var shouldReturnError = false
    var mockResponse: OffersResponse?

    func fetchOffers(page: Int) async throws -> OffersResponse {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        }
        if let response = mockResponse {
            return response
        }
        throw NetworkError.requestFailed
    }
}
