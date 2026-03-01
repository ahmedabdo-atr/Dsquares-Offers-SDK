import XCTest
@testable import DsquaresOffersSDK

@MainActor
final class OffersSDKTests: XCTestCase {
    
    // Just a reminder: when writing tests, we want to cover:
    func testOfferDecoding() throws {
        // Given json data for an offer
        let jsonString = """
        {
            "id": 101,
            "title": "50% Off Coffee",
            "description": "Get half price on your next coffee.",
            "imageUrl": "https://example.com/coffee.png"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When: we try to decode the JSON data into an Offer model
        let offer = try JSONDecoder().decode(Offer.self, from: jsonData)
        
        // Then: we verify that the data was correctly mapped
        XCTAssertEqual(offer.id, 101)
        XCTAssertEqual(offer.title, "50% Off Coffee")
        XCTAssertEqual(offer.description, "Get half price on your next coffee.")
    }
    
    // test the ViewModel's behavior when fetching the first page of offers successfully
    
    func testFetchFirstPageSuccess() async {
        // Given: a mock service that returns a successful response
        let mockService = MockNetworkService()
        let mockOffers = [Offer(id: 1, title: "Test Offer", description: "Desc", imageUrl: nil)]
        mockService.mockResponse = OffersResponse(data: mockOffers, totalPages: 1)
        
        let viewModel = OffersViewModel(networkService: mockService)
        
        // When: we call fetchFirstPage
        await viewModel.fetchFirstPage()
        
        // Then: we expect the ViewModel to update its state and offers list
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.offers.count, 1)
        XCTAssertEqual(viewModel.offers.first?.title, "Test Offer")
    }
    
    // test the ViewModel's behavior when fetching the first page of offers fails due to a network error
    func testFetchFirstPageFailure() async {
        // Given: a mock service that returns an error
        let mockService = MockNetworkService()
        mockService.shouldReturnError = true
        
        let viewModel = OffersViewModel(networkService: mockService)
        
        // When
        await viewModel.fetchFirstPage()
        
        // Then: we expect the ViewModel to update its state to error and set the error message
        if case .error(let message) = viewModel.state {
            XCTAssertEqual(message, NetworkError.invalidResponse.customMessage)
        } else {
            XCTFail("State should be error")
        }
    }
}
