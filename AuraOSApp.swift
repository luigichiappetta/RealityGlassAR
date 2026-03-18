import SwiftUI

@main
struct AuraOSApp: App {
    @StateObject private var arState = ARPresentationState()

    var body: some Scene {
        WindowGroup {
            ARWorldTrackingView()
                .environmentObject(arState)
        }
    }
}
