import Foundation
import simd

enum HandSide: UInt8 {
    case left = 0
    case right = 1
}

enum SensorSurface: UInt8 {
    case braceletLeft = 0
    case braceletRight = 1
    case widgetsPalm = 2
    case notificationCenter = 3
    case controlCenter = 4
}

struct SensorFrame {
    let timestampMs: UInt32
    let hand: HandSide
    let surface: SensorSurface
    let quat: simd_quatf
    let accelG: SIMD3<Float>
    let gyroDps: SIMD3<Float>
    let sequence: UInt8
}
