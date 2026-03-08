import XCTest
@testable import DsquaresOffersSDK

@MainActor
final class OffersSDKTests: XCTestCase {
    
    func testOffersViewModelFetchSuccess() async {
        // Given
        let mockService = MockNetworkService()
        let mockItems = [
            OfferDTO(id: 1, title: "Offer 1", description: nil, imageUrl: nil, brandName: "Brand", brandLogo: nil, expiryDate: nil, points: "100")
        ]
        mockService.mockOffersResponse = OffersResponseDTO(data: mockItems, totalCount: 1, currentPage: 1, totalPages: 1)
        
        let repository = OffersRepository(networkService: mockService)
        let useCase = GetOffersUseCase(repository: repository)
        let viewModel = OffersViewModel(getOffersUseCase: useCase)
        
        // When
        await viewModel.fetchFirstPage()
        
        // Then
        if case .loaded = viewModel.state {
            XCTAssertEqual(viewModel.offers.count, 1)
            XCTAssertEqual(viewModel.offers.first?.title, "Offer 1")
        } else {
            XCTFail("State should be loaded, but was \(viewModel.state)")
        }
    }
    
    func testLoginViewModelSuccess() async {
        // Given
        let mockService = MockNetworkService()
        let tokenResult = TokenResultDTO(tokenType: "Bearer", accessToken: "test_token", expiresInMins: 60, refreshToken: nil)
        mockService.mockLoginResponse = LoginResponseDTO(result: tokenResult, message: "Success", statusCode: 1, statusName: "OK", referenceCode: nil, errors: nil)
        
        let useCase = LoginUseCase(networkService: mockService)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        
        // When
        await viewModel.login(userIdentifier: "01012345678")
        
        // Then
        XCTAssertTrue(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoginViewModelFailure() async {
        // Given
        let mockService = MockNetworkService()
        mockService.shouldReturnError = true
        
        let useCase = LoginUseCase(networkService: mockService)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        
        // When
        await viewModel.login(userIdentifier: "01012345678")
        
        // Then
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
