import SwiftUI
import UIKit

@MainActor
final class SwiftUITextureBridge: ObservableObject {
    private let hostingController: UIHostingController<AnyView>
    private var displayLink: CADisplayLink?
    private var lastSent: CFTimeInterval = 0
    private let targetSize = CGSize(width: 512, height: 512)
    private let fps: Double = 12

    init(selectedApp: Binding<String?>) {
        hostingController = UIHostingController(
            rootView: AnyView(TexturePanelView(selectedApp: selectedApp))
        )
        hostingController.view.backgroundColor = .clear
        hostingController.view.isOpaque = false
        hostingController.view.bounds = CGRect(origin: .zero, size: targetSize)
    }

    func start() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick(_ link: CADisplayLink) {
        let interval = 1.0 / fps
        if link.timestamp - lastSent < interval { return }
        lastSent = link.timestamp

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        guard let data = image.pngData() else { return }
        UnityBridge.shared.sendUITexture(data.base64EncodedString())
    }
}

private struct TexturePanelView: View {
    @Binding var selectedApp: String?

    var body: some View {
        TabView {
            AppsPage(selectedApp: $selectedApp).padding(12).tag(0)
            WidgetsPage().padding(12).tag(1)
            ControlCenterPage().padding(12).tag(2)
            NotificationsPage().padding(12).tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.15), lineWidth: 1))
        )
    }
}
