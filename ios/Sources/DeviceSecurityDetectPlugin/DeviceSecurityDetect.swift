import Foundation
import UIKit

@objc public class DeviceSecurityDetect: NSObject {
    @objc public func isJailBreak() -> Bool {
        log("Checking if device is jailbroken")
        return hasCydiaInstalled() || isContainsSuspiciousApps() || isSuspiciousSystemPathsExists() || canEditSystemFiles();
    }

    @objc public func pinCheck(_ value: String) -> String {
        log("Checking PIN: \(value)")
        return value
    }

    func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    var suspiciousAppsPathToCheck: [String] {
        return [
            "/Applications/Cydia.app",
            "/Applications/blackra1n.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app"
        ]
    }
        
    var suspiciousSystemPathsToCheck: [String] {
        return [
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/private/var/lib/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/stash",
            "/private/var/tmp/cydia.log",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/usr/bin/sshd",
            "/usr/libexec/sftp-server",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/bin/bash",
            "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
