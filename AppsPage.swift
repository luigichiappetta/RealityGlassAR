import SwiftUI

struct AppsPage: View {
    @Binding var selectedApp: String?

    let apps: [(String, String)] = [
        ("Camera", "cameraIcon"),
        ("Photos", "photosIcon"),
        ("Maps", "mapsIcon"),
        ("Safari", "safariIcon"),
        ("Messages", "messagesIcon"),
        ("Calendar", "calendarIcon"),
        ("Notes", "notesIcon"),
        ("Music", "musicIcon"),
        ("Weather", "weatherIcon"),
        ("Clock", "clockIcon"),
        ("Calculator", "calculatorIcon"),
        ("Voice Recorder", "voiceRecorderIcon"),
        ("Fitness", "fitnessIcon"),
        ("Calls", "callsIcon"),
        ("Settings", "settingsIcon"),
        ("Files", "filesIcon")
    ]

    var body: some View {
        VStack(spacing: 12) {
            Text("Apps")
                .font(.headline)
                .foregroundColor(.white)

            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(apps, id: \.0) { app in
                        Button {
                            selectedApp = app.0
                        } label: {
                            VStack(spacing: 6) {
                                if let image = UIImage(named: app.1) {
                                    LiquidGlassAppIconView(image: image, style: .liquid)
                                        .frame(width: 52, height: 52)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 52, height: 52)
                                }
                                Text(app.0)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

