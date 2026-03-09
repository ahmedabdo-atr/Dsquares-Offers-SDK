# Dsquares Offers SDK & Host Application

This repository contains a professional-grade Native Mobile SDK for fetching and displaying merchant offers, along with a Host Application demonstrating its seamless integration. The project is designed strictly following iOS best practices, focusing on modularity, clean architecture, and high UI/UX fidelity.

## Architecture Overview

The solution follows a modular strategy, separating core logic from the user interface:

- **DsquaresOffersSDK:** A standalone Swift Package implementing the core rewards and loyalty logic. It follows Clean Architecture principles with clearly defined Layers (Data, Domain, Presentation).
- **OffersHostApp:** A lightweight demonstration application that integrates the SDK through a dedicated abstraction layer.

### Key Technical Pillars:
- **Presentation:** Built entirely with SwiftUI, utilizing the MVVM pattern. ViewModels manage internal states (Loading, Error, Loaded) using advanced state management.
- **Networking:** A robust, protocol-oriented networking layer using Swift's native `async/await`. It features flexible JSON decoding to handle diverse API response structures.
- **Modularity:** The SDK is completely isolated, exposing only necessary interfaces to ensure plug-and-play capability.

## Setup & Build Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ahmedabdo-atr/Dsquares-Offers-SDK.git
   ```
2. **Open the Workspace:**
   Open `DsquaresOffersWorkspace.xcworkspace` in Xcode. (Ensure you open the workspace to maintain package links).
3. **Run the Application:**
   Select the `OffersHostApp` target and a simulator (iOS 15.0+), then press `Cmd + R`.

## SDK Integration

Integrating the SDK is straightforward. The recommended approach is to use the `OffersSDKManager` abstraction:

```swift
import DsquaresOffersSDK

// In your Host App
OffersSDKManager.createOffersScreen()
```

## Features

- **Premium UI:** High-end design with glassmorphism, gradients, and a modern "Floating Card" login interface.
- **Smart Data Fetching:** Supports pagination and pull-to-refresh for an optimal user experience.
- **Robustness:** Comprehensive error handling and state feedback for offline or server-side issues.
- **Modularity:** Low coupling with the host app, making it easy to drop into any existing project.

Ahmad A. 09/03/2026.
