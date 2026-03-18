import SwiftUI

struct ControlCenterPage: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Control Center")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 12) {
                control(icon: "wifi", label: "Wi-Fi")
                control(icon: "bolt.fill", label: "Power")
                control(icon: "sun.max.fill", label: "Display")
            }
        }
    }

    private func control(icon: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(.white).font(.title3)
            Text(label).font(.caption2).foregroundColor(.white)
        }
        .frame(width: 92, height: 84)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
