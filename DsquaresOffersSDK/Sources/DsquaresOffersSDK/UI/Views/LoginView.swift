//
//  LoginView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import SwiftUI

public struct LoginView: View {
    @State private var phoneNumber = ""
    @Environment(\.dismiss) var dismiss
    
    public init() {}
    
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
            .padding(.horizontal)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Handle Login Logic
                }) {
                    Text("تسجيل الدخول")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DSColor.primary)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // Navigate to Offers directly as per Figma flow maybe?
                }) {
                    Text("القسائم")
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
    }
}
