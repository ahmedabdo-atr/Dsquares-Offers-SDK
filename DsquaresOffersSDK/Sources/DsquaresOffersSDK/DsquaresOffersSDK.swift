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
    
    /// Set this to true to use mock data instead of live API (useful for testing when IP is not whitelisted)
    private static let useMock = true // ⚠️ Change to false for Production
    
    private static func getNetworkService() -> OffersNetworkServiceProtocol {
        return useMock ? MockOffersNetworkService() : OffersNetworkService()
    }
    
    /// Entry point to create the Offers List screen.
    @MainActor
    public static func createOffersScreen() -> some View {
        let networkService = getNetworkService()
        let repository = OffersRepository(networkService: networkService)
        let getOffersUseCase = GetOffersUseCase(repository: repository)
        let viewModel = OffersViewModel(getOffersUseCase: getOffersUseCase)
        
        return NavigationView {
            OffersListView(viewModel: viewModel)
        }
    }
    
    /// Entry point to create the Login screen.
    @MainActor
    public static func createLoginScreen() -> some View {
        let networkService = getNetworkService()
        let loginUseCase = LoginUseCase(networkService: networkService)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        return LoginView(viewModel: viewModel)
    }
}
