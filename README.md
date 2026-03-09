# 🎁 Dsquares Offers SDK & Host App

A premium, modular Native iOS SDK built for seamless integration of loyalty rewards and merchant offers. This repository includes both the core **DsquaresOffersSDK** and a **Host Application** that showcases a high-fidelity user experience.

---

## 🚀 Key Features

- **💎 Elite UI/UX**: Modern design language featuring glassmorphism, smooth gradients, and a "Floating Card" login interface.
- **🔌 Plug & Play**: Fully decoupled Swift Package designed for effortless integration into any iOS project.
- **⚡️ Performance Driven**: Native `async/await` networking with optimized JSON parsing and smart pagination.
- **🏗️ Clean Architecture**: Strictly follows SOLID principles with clearly separated Domain, Data, and Presentation layers.
- **📱 Responsive States**: Built-in handling for all view states: `Loading`, `Empty`, `Error`, and `Loaded`.

---

## 🛠 Tech Stack & Architecture

The project is architected to be scalable and maintainable, avoiding "spaghetti" code while maintaining high performance.

- **UI Framework**: SwiftUI 5.0+
- **Pattern**: MVVM (Model-View-ViewModel) + Clean Architecture.
- **Networking**: Protocol-oriented `URLSession` with structured concurrency.
- **Dependency Management**: Swift Package Manager (SPM).
- **Minimum iOS**: 15.0

### Project Structure
- 📦 **DsquaresOffersSDK**: The core engine. Logic-heavy but interface-light.
- 📱 **OffersHostApp**: A lightweight shell demonstrating how to consume the SDK's entry points.

---

## ⚙️ Quick Start

1. **Clone the Repo**
   ```bash
   git clone https://github.com/ahmedabdo-atr/Dsquares-Offers-SDK.git
   ```

2. **Open the Project**
   Launch `DsquaresOffersWorkspace.xcworkspace` in Xcode. (Always use the workspace to ensure SPM links are resolved).

3. **Run it**
   Select the `OffersHostApp` target and hit `Cmd + R` on any iOS 15+ simulator.

---

## 🧩 Integration Guide

Integrating the offers screen into your app is a one-liner thanks to our `OffersSDKManager` abstraction:

```swift
import DsquaresOffersSDK

// Inside your SwiftUI View or Coordinator
let offersView = OffersSDKManager.createOffersScreen()
```

For the authentication flow:
```swift
let loginView = OffersSDKManager.createLoginScreen()
```

---

## 👷 Author

**Ahmad A.**  
*Senior iOS Developer*  
📅 *Last Updated: March 2026*

---
*Developed with ❤️ for a world-class rewards experience.*
