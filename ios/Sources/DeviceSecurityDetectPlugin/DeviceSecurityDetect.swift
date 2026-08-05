import Foundation
import LocalAuthentication

@objc public class DeviceSecurityDetect: NSObject {
    private let jailbreakDetector = JailbreakDetector(environment: LiveJailbreakDetectionEnvironment())

    @objc public func isJailBreak() -> Bool {
        log("Checking if device is jailbroken")
        #if targetEnvironment(simulator)
            log("Skipping jailbreak checks on simulator")
            return false
        #else
            return jailbreakDetector.isJailbroken()
        #endif
    }

    @objc public func pinCheck() -> Bool {
        log("Checking if PIN or biometric authentication is enabled")
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            return true
        } else {
            log("Error checking PIN/Biometric authentication: \(error?.localizedDescription ?? "Unknown error")")
            return false
        }
    }
}
