import SwiftUI

struct WidgetsPage: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Widgets").font(.headline).foregroundColor(.white)
            HStack(spacing: 12) {
                widget(title: "Weather", value: "14°")
                widget(title: "Calendar", value: "3 eventi")
            }
            HStack(spacing: 12) {
                widget(title: "Fitness", value: "540 kcal")
                widget(title: "Battery", value: "82%")
            }
        }
    }

    private func widget(title: String, value: String) -> some View {
        VStack {
            Text(title).font(.caption).foregroundColor(.white.opacity(0.8))
            Text(value).font(.headline).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
