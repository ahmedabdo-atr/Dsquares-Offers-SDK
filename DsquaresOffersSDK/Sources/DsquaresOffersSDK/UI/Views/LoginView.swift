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
            // Sophisticated Mesh-like Background
            LinearGradient(colors: [DSColor.secondaryBackground, Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Abstract Background Shapes
            VStack {
                Circle()
                    .fill(DSColor.primary.opacity(0.04))
                    .frame(width: 350, height: 350)
                    .offset(x: -100, y: -150)
                Spacer()
                Circle()
                    .fill(DSColor.primary.opacity(0.06))
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: 100)
            }
            
            VStack(spacing: 0) {
                // Brand Header Section
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
                        
                        Image(systemName: "gift.fill")
                            .font(.system(size: 45))
                            .foregroundColor(DSColor.primary)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Dsquares")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(DSColor.textPrimary)
                        Text("E X C L U S I V E S")
                            .font(.system(size: 10, weight: .bold))
                            .kerning(4)
                            .foregroundColor(DSColor.primary)
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Login Card (The Floating Look)
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Secure Login")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(DSColor.textPrimary)
                        
                        // Input Field with Prefix
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mobile Number")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(DSColor.textSecondary)
                            
                            HStack(spacing: 12) {
                                HStack(spacing: 6) {
                                    Text("🇪🇬")
                                    Text("+20")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .padding(.trailing, 8)
                                .overlay(
                                    Rectangle().fill(DSColor.border).frame(width: 1).padding(.vertical, 4),
                                    alignment: .trailing
                                )
                                
                                TextField("10XXXXXXXX", text: $phoneNumber)
                                    .font(.system(size: 16, weight: .semibold))
                                    #if os(iOS)
                                    .keyboardType(.phonePad)
                                    #endif
                            }
                            .padding(18)
                            .background(DSColor.secondaryBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(viewModel.errorMessage != nil ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1.5)
                            )
                        }
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.top, -15)
                    }
                    
                    // Main Action Button
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
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            ZStack {
                                if phoneNumber.isEmpty || viewModel.isLoading {
                                    Color.gray.opacity(0.3)
                                } else {
                                    LinearGradient(
                                        colors: [DSColor.primary, Color(hex: "FF4D67")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(18)
                        .shadow(color: DSColor.primary.opacity(phoneNumber.isEmpty ? 0 : 0.3), radius: 12, x: 0, y: 6)
                    }
                    .disabled(viewModel.isLoading || phoneNumber.isEmpty)
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(32)
                .shadow(color: Color.black.opacity(0.08), radius: 30, x: 0, y: 15)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onReceive(viewModel.$isLoggedIn) { loggedIn in
            if loggedIn {
                dismiss()
            }
        }
    }
}
