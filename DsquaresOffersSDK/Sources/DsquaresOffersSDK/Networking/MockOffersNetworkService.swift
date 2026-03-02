//
//  MockOffersNetworkService.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

public final class MockOffersNetworkService: OffersNetworkServiceProtocol, @unchecked Sendable {
    
    private var accessToken: String?
    
    public init() {}
    
    public func login(userIdentifier: String) async throws -> LoginResponseDTO {
        // Simulate a short network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful login response
        let tokenResult = TokenResultDTO(
            tokenType: "Bearer",
            accessToken: "mock_jwt_token_for_testing",
            expiresIn: 3600,
            refreshToken: "mock_refresh_token"
        )
        
        let response = LoginResponseDTO(
            result: tokenResult,
            message: "Success",
            statusCode: 1,
            statusName: "OK"
        )
        
        self.accessToken = tokenResult.accessToken
        return response
    }
    
    public func fetchOffers(page: Int) async throws -> OffersResponseDTO {
        // Simulate a short network delay
        try await Task.sleep(nanoseconds: 800_000_000)
        
        // Mock list of offers
        let mockOffers = [
            OfferDTO(
                id: 1,
                title: "خصم 50% على الملابس",
                description: "استمتع بخصم حصري على جميع الملابس الرجالي والنسائي في جميع فروعنا.",
                imageUrl: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=500&auto=format&fit=crop",
                brandName: "زارا - Zara",
                brandLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/512px-Zara_Logo.svg.png",
                expiryDate: "2026-12-31"
            ),
            OfferDTO(
                id: 2,
                title: "اشتري 1 واحصل على 1 مجاناً",
                description: "عرض خاص على جميع أنواع البرجر والبطاطس لفترة محدودة جداً.",
                imageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=500&auto=format&fit=crop",
                brandName: "ماكدونالدز - McDonald's",
                brandLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/512px-McDonald%27s_Golden_Arches.svg.png",
                expiryDate: "2026-06-15"
            ),
            OfferDTO(
                id: 3,
                title: "خصم 100 جنيه على أول طلب",
                description: "اطلب الآن من خلال تطبيقنا واستخدم بروموكود NEW100 للحصول على الخصم.",
                imageUrl: "https://images.unsplash.com/photo-1526367790999-0150786486a9?q=80&w=500&auto=format&fit=crop",
                brandName: "أمازون - Amazon",
                brandLogo: "https://upload.wikimedia.org/wikipedia/commons/4/4a/Amazon_icon.svg",
                expiryDate: "2026-09-01"
            )
        ]
        
        return OffersResponseDTO(
            data: mockOffers,
            totalCount: 3,
            currentPage: page,
            totalPages: 1
        )
    }
}
