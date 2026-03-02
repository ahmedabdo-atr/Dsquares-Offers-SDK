//
//  ContentView.swift
//  OffersHostApp
//
//  Created by Ahmed A. on 01/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogin = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "gift.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("Welcome to Host App")
                .font(.system(size: 34, weight: .bold))
            
            Text("This app integrates the Dsquares SDK seamlessly.")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showLogin = true
            }) {
                Text("View Exclusive Offers")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0/255, green: 132/255, blue: 255/255)) // Brand Blue
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        .sheet(isPresented: $showLogin) {
            OffersSDKManager.createLoginScreen()
        }
    }
}
