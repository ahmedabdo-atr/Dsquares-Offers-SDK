//
//  LoginView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import SwiftUI

public struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var phoneNumber = ""
    @Environment(\.dismiss) var dismiss
    
    public init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Text Content
            VStack(spacing: 8) {
                Text("ادخل رقم الهاتف")
                    .font(.system(size: 22, weight: .bold))
                
                Text("من فضلك ادخل رقم الهاتف لتسجيل الدخول")
                    .font(.system(size: 14))
                    .foregroundColor(DSColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .environment(\.layoutDirection, .rightToLeft)
            
            // Input Field
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Image(systemName: "iphone")
                        .foregroundColor(.gray)
                    
                    TextField("ادخل رقم الهاتف", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
                .background(DSColor.secondaryBackground)
                .cornerRadius(12)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    Task {
                        await viewModel.login(userIdentifier: phoneNumber)
                    }
                }) {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("تسجيل الدخول")
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(phoneNumber.isEmpty ? Color.gray.opacity(0.5) : DSColor.primary)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading || phoneNumber.isEmpty)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("إلغاء")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(DSColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DSColor.secondaryBackground)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .onChange(of: viewModel.isLoggedIn) { loggedIn in
            if loggedIn {
                dismiss() // Close login on success
            }
        }
    }
}
