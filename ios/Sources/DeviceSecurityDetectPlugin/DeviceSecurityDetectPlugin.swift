import Foundation
import Capacitor

@objc(DeviceSecurityDetectPlugin)
public class DeviceSecurityDetectPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DeviceSecurityDetectPlugin"
    public let jsName = "DeviceSecurityDetect"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "isJailBreakOrRooted", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = DeviceSecurityDetect()

    @objc func isJailBreakOrRooted(_ call: CAPPluginCall) {
        call.resolve([
            "value": implementation.isJailBreak()
        ])
    }
}
