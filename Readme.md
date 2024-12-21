# RoofingEstimator
 RoofingEstimator is an iOS application designed to create roofing estimates and allow customers to view stored estimates using an access code.

# Design Considerations
- MVVM (Model-View-ViewModel) architecture.
- Coordinator Pattern: Used to manage navigation flow and the presentation of view controllers.
- Implemented using Swift for functionality and SwiftUI for the user interface.
- SOLID Principles for clean code structure.
- Dependency Injection for better code modularity and testability.
- Unit Testing with XCTest.
- Data persistence using Core Data.
- Screenshots and demo video included for reference.

# Prerequisites
- Xcode 16 or later
- iOS 18.0 or later

# Usage
- Launch the app on your iOS device or simulator (Face ID permissions need to be set up on the simulator).
- The home screen will display two buttons: 1) Create Estimate and 2) Customer Access.
- Create an estimate, and the calculated values displayed at the bottom of the screen are updated in real-time.
- Save the estimate and note down the access code. The access codes start from 1000 for simplicity; however, UUID could be a good candidate for unique identification.
- Open the Customer Access screen and enter the access code.
