//
//  LoginViewModel.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isLoggedIn = false
    
    private let loginUseCase: LoginUseCaseProtocol
    
    public init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    public func login(userIdentifier: String) async {
        print("👤 [ViewModel] Attempting login for \(userIdentifier)...")
        guard !userIdentifier.isEmpty else {
            errorMessage = "Please enter a valid identifier"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let success = try await loginUseCase.execute(userIdentifier: userIdentifier)
            if success {
                print("👤 [ViewModel] Login succeeded!")
                isLoggedIn = true
            } else {
                print("👤 [ViewModel] Login failed (logic returned false)")
                errorMessage = "Authentication failed. Please try again."
            }
        } catch let error as NetworkError {
            print("👤 [ViewModel] Network error: \(error.customMessage)")
            errorMessage = error.customMessage
        } catch {
            print("👤 [ViewModel] Unexpected error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
