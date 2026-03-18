import SwiftUI
import UIKit

enum IconStyle: String, CaseIterable, Hashable {
    case light, dark, liquid, colored
}

struct LiquidGlassAppIconView: View {
    let image: UIImage
    let style: IconStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding(8)
        }
    }
}
