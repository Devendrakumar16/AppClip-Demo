# QuickCoffee App Clip - Instant iOS Coffee Ordering

An iOS App Clip demonstration enabling lightweight, instantaneous coffee browsing and order initiation directly from NFC tags, QR codes, or Safari App Banners without downloading the full app.

---

## 🛠️ Tech Stack & Architecture
`SwiftUI` `App Clips Framework` `URL Routing` `MVVM` `Swift Concurrency`

- **Platform:** iOS 16.0+
- **Language:** Swift 5.10+
- **Framework:** SwiftUI
- **Architecture:** MVVM / Clean Architecture

---

## ✨ Key Features
- Instant launch under standard App Clip payload limits (< 15MB)
- Dynamic coffee catalog fetched from remote JSON/APIs
- Smooth transition paths to upgrade to the parent application
- Responsive SwiftUI screens with customized typography and animations

---

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma or newer
- Xcode 15.0 or newer
- iOS Simulator or physical device running iOS 16+

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Devendrakumar16/AppClip-Demo.git
   cd AppClip-Demo
   ```
2. Open the project in Xcode:
   ```bash
   open *.xcodeproj 2>/dev/null || open *.xcworkspace
   ```
3. If CocoaPods is used:
   ```bash
   pod install
   open *.xcworkspace
   ```
4. Select your target simulator (e.g., iPhone 15 Pro) and press `Cmd + R` to build and run!

---

## 👨‍💻 Author
- **Devendra Kumar** ([@Devendrakumar16](https://github.com/Devendrakumar16))

---

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
