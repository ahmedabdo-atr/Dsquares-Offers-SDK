//
//  ContentView.swift
//  OffersHostApp
//
//  Created by Ahmad A. on 09/03/2026.
//

import SwiftUI
import DsquaresOffersSDK

struct ContentView: View {
    @State private var showLogin = false
    @State private var showOffers = false
    
    private let primaryRed = Color(red: 225/255, green: 25/255, blue: 55/255)
    private let secondaryRed = Color(red: 255/255, green: 77/255, blue: 103/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack {
                    Circle()
                        .fill(primaryRed.opacity(0.04))
                        .frame(width: 400, height: 400)
                        .offset(x: -150, y: -100)
                    Spacer()
                    Circle()
                        .fill(primaryRed.opacity(0.06))
                        .frame(width: 300, height: 300)
                        .offset(x: 180, y: 150)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 40) {
                        ZStack {
                            Circle()
                                .fill(primaryRed.opacity(0.1))
                                .frame(width: 180, height: 180)
                                .scaleEffect(1.1)
                            
                            Image(systemName: "gift.fill")
                                .font(.system(size: 85))
                                .foregroundColor(primaryRed)
                                .shadow(color: primaryRed.opacity(0.3), radius: 25, x: 0, y: 15)
                        }
                        
                        VStack(spacing: 16) {
                            Text("Experience Rewards")
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundColor(Color(red: 26/255, green: 28/255, blue: 30/255))
                                .multilineTextAlignment(.center)
                            
                            Text("Discover a world of exclusive offers and loyalty rewards with the Dsquares SDK integration.")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            showLogin = true
                        }) {
                            HStack {
                                Text("Explore Exclusive Offers")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .heavy))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 65)
                            .background(
                                LinearGradient(
                                    colors: [primaryRed, secondaryRed],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(22)
                            .shadow(color: primaryRed.opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                        .padding(.horizontal, 30)
                        
                        Text("Powered by Dsquares Integration")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary.opacity(0.6))
                            .kerning(1)
                    }
                    .padding(.bottom, 40)
                    
                    NavigationLink(destination: OffersSDKManager.createOffersScreen(), isActive: $showOffers) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showLogin, onDismiss: {
                showOffers = true 
            }) {
                OffersSDKManager.createLoginScreen()
            }
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}
