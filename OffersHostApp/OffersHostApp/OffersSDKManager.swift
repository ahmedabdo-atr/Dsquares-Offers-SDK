//
//  OffersSDKManager.swift
//  OffersHostApp
//
//  Created by Ahmad A. on 09/03/2026.
//

import SwiftUI
import Foundation
import DsquaresOffersSDK

public struct OffersSDKManager {
    public static func createOffersScreen() -> some View {
        return DsquaresOffersSDK.OffersSDKManager.createOffersScreen()
    }

    public static func createLoginScreen() -> some View {
        return DsquaresOffersSDK.OffersSDKManager.createLoginScreen()
    }
}
