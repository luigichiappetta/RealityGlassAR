import SwiftUI
import UIKit

struct UnityARContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        if let view = UnityBridge.shared.unityRootView() {
            view.backgroundColor = .black
            return view
        }
        let fallback = UIView(frame: .zero)
        fallback.backgroundColor = .black
        return fallback
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
