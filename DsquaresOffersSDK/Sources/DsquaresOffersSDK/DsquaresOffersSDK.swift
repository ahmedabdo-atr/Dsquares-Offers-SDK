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
    @MainActor
    public static func createOffersScreen() -> some View {
        let networkService = OffersNetworkService()
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
        let networkService = OffersNetworkService()
        let loginUseCase = LoginUseCase(networkService: networkService)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        return LoginView(viewModel: viewModel)
    }
}
