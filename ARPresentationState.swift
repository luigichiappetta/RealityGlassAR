import Foundation

enum ARSurface: String, CaseIterable {
    case braceletLeft
    case braceletRight
    case widgetsPalm
    case notificationCenter
    case controlCenter
}

@MainActor
final class ARPresentationState: ObservableObject {
    @Published private(set) var surface: ARSurface = .braceletLeft
    @Published private(set) var selectedApp: String? = nil

    func setSurface(_ value: ARSurface) {
        surface = value
    }

    func setSelectedApp(_ value: String?) {
        selectedApp = value
    }
}
