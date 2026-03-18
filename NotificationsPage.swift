import SwiftUI

struct NotificationsPage: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Notifications")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(0..<3, id: \.self) { idx in
                HStack(alignment: .top) {
                    Circle().fill(Color.white.opacity(0.4)).frame(width: 22, height: 22)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notifica \(idx + 1)").foregroundColor(.white)
                        Text("Anteprima notifica AR").foregroundColor(.white.opacity(0.75)).font(.caption)
                    }
                    Spacer()
                }
                .padding(10)
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
