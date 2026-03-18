import SwiftUI

struct ARWorldTrackingView: View {
    @EnvironmentObject private var arState: ARPresentationState
    @StateObject private var sensorManager = SensorInputManager()
    @State private var selectedApp: String? = nil
    @StateObject private var textureBridgeHolder = TextureBridgeHolder()

    var body: some View {
        ZStack {
            if UnityBridge.shared.isAvailable {
                UnityARContainer()
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                Text("UnityFramework non trovato. Fallback attivo.")
                    .foregroundColor(.white)
            }

            if let app = selectedApp {
                AppOverlayView(appName: app) {
                    selectedApp = nil
                }
            }
        }
        .onAppear {
            let bridge = SwiftUITextureBridge(selectedApp: $selectedApp)
            textureBridgeHolder.bridge = bridge
            bridge.start()
            sensorManager.start()
        }
        .onDisappear {
            textureBridgeHolder.bridge?.stop()
            sensorManager.stop()
        }
        .onReceive(sensorManager.$surface) { surface in
            arState.setSurface(surface)
            UnityBridge.shared.sendSurface(surface)
        }
        .onChange(of: selectedApp) { _, value in
            arState.setSelectedApp(value)
            UnityBridge.shared.sendSelectedApp(value)
        }
    }
}

@MainActor
final class TextureBridgeHolder: ObservableObject {
    var bridge: SwiftUITextureBridge?
}
