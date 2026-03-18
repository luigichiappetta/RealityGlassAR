import Foundation

@MainActor
final class SensorInputManager: ObservableObject {
    @Published private(set) var surface: ARSurface = .braceletLeft
    @Published private(set) var selectedApp: String? = nil

    private let transport: SensorTransport

    init(transport: SensorTransport = GameControllerSensorTransport()) {
        self.transport = transport
    }

    func start() {
        transport.start { [weak self] frame in
            Task { @MainActor in
                self?.surface = Self.map(frame.surface)
            }
        }
    }

    func stop() {
        transport.stop()
    }

    private static func map(_ surface: SensorSurface) -> ARSurface {
        switch surface {
        case .braceletLeft: return .braceletLeft
        case .braceletRight: return .braceletRight
        case .widgetsPalm: return .widgetsPalm
        case .notificationCenter: return .notificationCenter
        case .controlCenter: return .controlCenter
        }
    }
}
