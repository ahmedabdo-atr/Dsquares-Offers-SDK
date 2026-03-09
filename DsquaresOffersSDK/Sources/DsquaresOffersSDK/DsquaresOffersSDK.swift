//
//  DsquaresOffersSDK.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
//

import SwiftUI

public struct OffersSDKManager {
    private static let useMock = false
    
    private static func getNetworkService() -> OffersNetworkServiceProtocol {
        return useMock ? MockOffersNetworkService.shared : OffersNetworkService.shared
    }
    
    @MainActor
    public static func createOffersScreen() -> some View {
        let networkService = getNetworkService()
        let repository = OffersRepository(networkService: networkService)
        let getOffersUseCase = GetOffersUseCase(repository: repository)
        let viewModel = OffersViewModel(getOffersUseCase: getOffersUseCase)
        
        return OffersListView(viewModel: viewModel)
    }
    
    @MainActor
    public static func createLoginScreen() -> some View {
        let networkService = getNetworkService()
        let loginUseCase = LoginUseCase(networkService: networkService)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        return LoginView(viewModel: viewModel)
    }
}
