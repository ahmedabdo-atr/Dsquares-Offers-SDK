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
        // In a real implementation, you might want to pass some configuration or user data to the SDK here
        return OffersListView()
    }
}
