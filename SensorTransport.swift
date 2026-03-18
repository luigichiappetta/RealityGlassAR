import Foundation
import GameController

protocol SensorTransport: AnyObject {
    var isRunning: Bool { get }
    func start(onFrame: @escaping (SensorFrame) -> Void)
    func stop()
}

final class GameControllerSensorTransport: NSObject, SensorTransport {
    private(set) var isRunning = false
    private var onFrame: ((SensorFrame) -> Void)?

    func start(onFrame: @escaping (SensorFrame) -> Void) {
        self.onFrame = onFrame
        isRunning = true
    }

    func stop() {
        isRunning = false
        onFrame = nil
    }
}
