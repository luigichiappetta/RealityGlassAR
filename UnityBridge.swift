import Foundation
import UIKit

#if canImport(UnityFramework)
import UnityFramework

final class UnityBridge: NSObject {
    static let shared = UnityBridge()

    private var unityFramework: UnityFramework?
    private var isStarted = false

    func unityRootView() -> UIView? {
        startIfNeeded()
        return unityFramework?.appController()?.rootView
    }

    var isAvailable: Bool {
        let frameworkURL = Bundle.main.bundleURL.appendingPathComponent("Frameworks/UnityFramework.framework")
        return FileManager.default.fileExists(atPath: frameworkURL.path)
    }

    func startIfNeeded() {
        guard !isStarted else { return }
        guard let bundle = Bundle(url: Bundle.main.bundleURL.appendingPathComponent("Frameworks/UnityFramework.framework")) else { return }
        if !bundle.isLoaded {
            bundle.load()
        }
        guard let principalClass = bundle.principalClass as? UnityFramework.Type else { return }
        let framework = principalClass.getInstance()
        framework.setDataBundleId("com.unity3d.framework")
        framework.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        unityFramework = framework
        isStarted = true
    }

    func sendSurface(_ surface: ARSurface) {
        sendMessage(function: "SetSurface", payload: surface.rawValue)
    }

    func sendSelectedApp(_ appName: String?) {
        sendMessage(function: "SetSelectedApp", payload: appName ?? "")
    }

    func sendUITexture(_ base64: String) {
        sendMessage(function: "UpdateTexture", payload: base64)
    }

    private func sendMessage(function: String, payload: String) {
        unityFramework?.sendMessageToGO(withName: "AuraOSBridge", functionName: function, message: payload)
    }
}

#else

final class UnityBridge {
    static let shared = UnityBridge()

    func unityRootView() -> UIView? { nil }
    var isAvailable: Bool { false }
    func startIfNeeded() {}
    func sendSurface(_ surface: ARSurface) {}
    func sendSelectedApp(_ appName: String?) {}
    func sendUITexture(_ base64: String) {}
}

#endif
