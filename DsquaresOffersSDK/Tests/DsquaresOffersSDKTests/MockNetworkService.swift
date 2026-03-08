import Foundation
@testable import DsquaresOffersSDK

final class MockNetworkService: OffersNetworkServiceProtocol, @unchecked Sendable {
    var shouldReturnError = false
    var mockLoginResponse: LoginResponseDTO?
    var mockOffersResponse: OffersResponseDTO?
    
    func login(userIdentifier: String) async throws -> LoginResponseDTO {
        if shouldReturnError {
            throw NetworkError.requestFailed
        }
        if let response = mockLoginResponse {
            return response
        }
        throw NetworkError.invalidResponse(400)
    }
    
    func fetchOffers(page: Int) async throws -> OffersResponseDTO {
        if shouldReturnError {
            throw NetworkError.requestFailed
        }
        if let response = mockOffersResponse {
            return response
        }
        throw NetworkError.invalidResponse(400)
    }
}
