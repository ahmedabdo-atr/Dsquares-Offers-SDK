//
//  DsquaresOffersSDK.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import SwiftUI

/// Public interface for the Dsquares Offers SDK.
/// The host application should interact with the SDK primarily through this manager.
public struct OffersSDKManager {
    
    /// Entry point to create the Offers List screen.
    /// This handles dependency injection internally.
    @MainActor
    public static func createOffersScreen() -> some View {
        // Compose dependencies
        let networkService = OffersNetworkService()
        let repository = OffersRepository(networkService: networkService)
        let getOffersUseCase = GetOffersUseCase(repository: repository)
        let viewModel = OffersViewModel(getOffersUseCase: getOffersUseCase)
        
        return NavigationView {
            OffersListView(viewModel: viewModel)
        }
    }
}
