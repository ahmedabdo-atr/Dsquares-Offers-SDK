//
//  LoginUseCase.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

public protocol LoginUseCaseProtocol: Sendable {
    func execute(userIdentifier: String) async throws -> Bool
}

public final class LoginUseCase: LoginUseCaseProtocol {
    private let networkService: OffersNetworkServiceProtocol
    
    public init(networkService: OffersNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func execute(userIdentifier: String) async throws -> Bool {
        let response = try await networkService.login(userIdentifier: userIdentifier)
        // Login is successful if we have an access token and status is 1
        return response.result?.accessToken != nil && response.statusCode == 1
    }
}
