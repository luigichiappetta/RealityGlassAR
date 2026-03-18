import SwiftUI

struct AppOverlayView: View {
    let appName: String
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(appName)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            Button("Chiudi") {
                onClose()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
