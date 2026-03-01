# Dsquares Offers SDK & Host Application

This repository contains a production-ready Native Mobile SDK for fetching and displaying merchant offers, along with a Host Application demonstrating its seamless integration. The project is designed strictly following iOS best practices, focusing on modularity, clean architecture, and UI/UX fidelity.

## 🏗 Architecture Overview

The solution is divided into two main components: an isolated SDK and a lightweight Host App. 

The SDK (`OffersSDK`) is implemented as a **Local Swift Package**. This ensures complete isolation from the host application and guarantees that the host app can only interact with the SDK through its defined public interface. 

[cite_start]Within the SDK, I utilized the **MVVM (Model-View-ViewModel)** pattern combined with principles of Clean Architecture[cite: 62]:
* **Presentation Layer:** Handled by SwiftUI Views and `ObservableObject` ViewModels. The ViewModels map data and manage UI states (Loading, Loaded, Empty, Error) internally, abstracting this logic from the Host App.
* **Domain Layer:** Business rules, such as pagination logic and data validation, are encapsulated here.
* **Data Layer:** A robust Networking service utilizing Swift's native `async/await` concurrency mechanism. It includes comprehensive error handling (e.g., offline states, invalid responses) and uses Protocols for dependency injection to facilitate unit testing.

## 🚀 Setup & Build Instructions

1. Clone the repository:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/Dsquares-Offers-SDK.git](https://github.com/YOUR_USERNAME/Dsquares-Offers-SDK.git)
Open the workspace file DsquaresOffersWorkspace.xcworkspace in Xcode (Do not open the .xcodeproj files directly to maintain the package links).

Ensure the target is set to OffersHostApp.

Select an iOS Simulator running iOS 15.0 or later.

Press Cmd + R to build and run the application.

🔌 SDK Public Interface & Integration
The SDK is designed to be plug-and-play. All internal logic (networking, state management, caching) is completely hidden from the Host App.

1. Integration Layer
The Host App utilizes a simple abstraction layer OffersSDKManager to interact with the SDK. This prevents tight coupling.

Swift
import SwiftUI
import OffersSDK

public struct OffersSDKManager {
    public static func createOffersScreen() -> some View {
        return OffersListView()
    }
}
2. Presenting the SDK
The host app can present the SDK effortlessly from any standard View hierarchy.

Swift
// Inside your Host App View
.sheet(isPresented: $showOffers) {
    OffersSDKManager.createOffersScreen()
}
✨ Key Features Implemented
Native Concurrency: async/await for efficient and readable networking.

Pagination & Pull-to-Refresh: Seamless data navigation as per API capabilities.

State Isolation: The SDK manages its own loading indicators and offline warnings.

Unit Testing: Critical components including networking mapping and business logic are fully tested.
