import XCTest
@testable import DsquaresOffersSDK

final class OffersMappingTests: XCTestCase {
    
    func testItemDTOMappingToDomain() {
        // Given: A raw ItemDTO from the API
        let denom = DenominationDTO(brand: "Starbucks", value: 50, points: 500)
        let itemDTO = ItemDTO(
            code: "b-123",
            name: "Free Coffee",
            description: "A free cup of coffee",
            imageUrl: "https://example.com/coffee.jpg",
            rewardType: "GiftCards",
            locked: true,
            denominations: [denom]
        )
        
        // When: Mapping to domain entity
        let offer = itemDTO.toDomain()
        
        // Then: Verification
        XCTAssertEqual(offer.id, 123)
        XCTAssertEqual(offer.title, "Free Coffee")
        XCTAssertEqual(offer.merchantName, "Starbucks")
        XCTAssertEqual(offer.points, "500")
        XCTAssertTrue(offer.isLocked)
        XCTAssertEqual(offer.rewardType, "GiftCards")
        XCTAssertEqual(offer.imageUrl?.absoluteString, "https://example.com/coffee.jpg")
    }
    
    func testOfferDTOMappingToDomain() {
        // Given: A legacy OfferDTO
        let offerDTO = OfferDTO(
            id: 456,
            title: "Discount",
            description: "10% off",
            imageUrl: "https://example.com/promo.png",
            brandName: "Nike",
            brandLogo: nil,
            expiryDate: nil,
            isLocked: false,
            rewardType: "Discounts",
            points: "100"
        )
        
        // When: Mapping to domain
        let offer = offerDTO.toDomain()
        
        // Then
        XCTAssertEqual(offer.id, 456)
        XCTAssertEqual(offer.merchantName, "Nike")
        XCTAssertEqual(offer.points, "100")
        XCTAssertFalse(offer.isLocked)
    }
}
