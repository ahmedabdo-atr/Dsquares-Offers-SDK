import XCTest
@testable import DsquaresOffersSDK

final class OffersRepositoryTests: XCTestCase {
    
    func testGetOffersMapsCorrectly() async throws {
        // Given
        let mockService = MockNetworkService()
        let offerDTO = OfferDTO(
            id: 99,
            title: "Repo Test Offer",
            description: "Desc",
            imageUrl: nil,
            brandName: "Test Brand",
            brandLogo: nil,
            expiryDate: nil,
            isLocked: false,
            rewardType: "Discounts",
            points: "123"
        )
        mockService.mockOffersResponse = OffersResponseDTO(data: [offerDTO], totalCount: 1, currentPage: 1, totalPages: 1)
        
        let repository = OffersRepository(networkService: mockService)
        
        // When
        let offers = try await repository.getOffers(page: 1)
        
        // Then
        XCTAssertEqual(offers.count, 1)
        XCTAssertEqual(offers.first?.id, 99)
        XCTAssertEqual(offers.first?.merchantName, "Test Brand")
        XCTAssertEqual(offers.first?.points, "123")
    }
}
