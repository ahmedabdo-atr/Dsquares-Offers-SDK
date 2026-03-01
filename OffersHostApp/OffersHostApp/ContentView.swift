//
//  ContentView.swift
//  OffersHostApp
//
//  Created by Ahmed A. on 01/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showOffers = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "gift.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("Welcome to Host App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This app integrates the Dsquares SDK seamlessly.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showOffers = true
            }) {
                Text("View Exclusive Offers")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        // عرض شاشة الـ SDK بطريقة سهلة ومودرن
        .sheet(isPresented: $showOffers) {
            OffersSDKManager.createOffersScreen()
        }
    }
}
