import SwiftUI

public struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var phoneNumber = ""
    @Environment(\.dismiss) var dismiss
    
    public init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            DSColor.background.ignoresSafeArea()
            
            // Background Elements for premium look
            VStack {
                Circle()
                    .fill(DSColor.primary.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .offset(x: -150, y: -100)
                Spacer()
                Circle()
                    .fill(DSColor.primary.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .offset(x: 150, y: 100)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Welcome Section
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(DSColor.primary)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10)
                        )
                    
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(DSTypography.title())
                            .foregroundColor(DSColor.textPrimary)
                        
                        Text("Please enter your phone number to continue exploring premium status and rewards.")
                            .font(DSTypography.body())
                            .foregroundColor(DSColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                
                // Input Section
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(DSTypography.caption().bold())
                            .foregroundColor(DSColor.textPrimary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(DSColor.textSecondary)
                                .font(.system(size: 16))
                            
                            TextField("e.g. 010XXXXXXXX", text: $phoneNumber)
                                .font(DSTypography.body())
                                #if os(iOS)
                                .keyboardType(.phonePad)
                                #endif
                        }
                        .padding(16)
                        .background(DSColor.surface)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.errorMessage != nil ? Color.red.opacity(0.5) : DSColor.border, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.02), radius: 5)
                    }
                    
                    if let error = viewModel.errorMessage {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(error)
                        }
                        .font(DSTypography.caption())
                        .foregroundColor(.red)
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        Task {
                            await viewModel.login(userIdentifier: phoneNumber)
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                Image(systemName: "arrow.right")
                            }
                        }
                        .font(DSTypography.body().bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Group {
                                if phoneNumber.isEmpty || viewModel.isLoading {
                                    Color.gray.opacity(0.4)
                                } else {
                                    LinearGradient(colors: [DSColor.primary, DSColor.primary.opacity(0.85)], startPoint: .leading, endPoint: .trailing)
                                }
                            }
                        )
                        .cornerRadius(14)
                        .shadow(color: DSColor.primary.opacity(phoneNumber.isEmpty ? 0 : 0.3), radius: 8, y: 4)
                    }
                    .disabled(viewModel.isLoading || phoneNumber.isEmpty)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Maybe Later")
                            .font(DSTypography.body().bold())
                            .foregroundColor(DSColor.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .onReceive(viewModel.$isLoggedIn) { loggedIn in
            if loggedIn {
                dismiss()
            }
        }
    }
}
