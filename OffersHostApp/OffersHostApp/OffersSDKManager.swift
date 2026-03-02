//
//  OffersSDKManager.swift
//  OffersHostApp
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import SwiftUI
import Foundation
import DsquaresOffersSDK // can import the SDK because it's added as a dependency in the Package.swift file
// This is the abstraction layer requested to isolate the app from the SDK
public struct OffersSDKManager {
    
    // A very simple function that the app calls to get the offers screen
    public static func createOffersScreen() -> some View {
        return DsquaresOffersSDK.OffersSDKManager.createOffersScreen()
    }

    public static func createLoginScreen() -> some View {
        return DsquaresOffersSDK.OffersSDKManager.createLoginScreen()
    }
}
