import Foundation
import MachO
import UIKit

protocol JailbreakDetectionEnvironment {
    func canOpen(_ url: URL) -> Bool
    func fileExists(atPath path: String) -> Bool
    func contentsOfDirectory(atPath path: String) -> [String]?
    func canWriteOutsideSandbox() -> Bool
    func canConnectToLocalPort(_ port: UInt16) -> Bool
    func loadedImageIdentifiers() -> [String]
    var processEnvironment: [String: String] { get }
}

struct JailbreakDetector {
    private let environment: JailbreakDetectionEnvironment

    init(environment: JailbreakDetectionEnvironment) {
        self.environment = environment
    }

    func isJailbroken() -> Bool {
        return hasSuspiciousProcessEnvironment()
            || hasSuspiciousLocalEndpoint()
            || hasSuspiciousLoadedImage()
            || hasSuspiciousURLScheme()
            || hasSuspiciousFile()
            || hasSuspiciousDirectory()
            || hasSuspiciousDirectoryEntry()
            || hasSuspiciousApplication()
            || environment.canWriteOutsideSandbox()
    }

    private func hasSuspiciousLocalEndpoint() -> Bool {
        return fridaLocalPorts.contains(where: environment.canConnectToLocalPort)
    }

    private func hasSuspiciousProcessEnvironment() -> Bool {
        for (key, value) in environment.processEnvironment {
            let normalizedKey = key.lowercased()
            let normalizedValue = value.lowercased()

            if suspiciousEnvironmentKeys.contains(normalizedKey)
                || normalizedKey.contains("frida")
                || suspiciousImageTokens.contains(where: normalizedValue.contains) {
                return true
            }
        }

        return false
    }

    private func hasSuspiciousLoadedImage() -> Bool {
        return environment.loadedImageIdentifiers().contains { identifier in
            let normalizedIdentifier = identifier.lowercased()
            return suspiciousImageTokens.contains(where: normalizedIdentifier.contains)
        }
    }

    private func hasSuspiciousURLScheme() -> Bool {
        return suspiciousURLSchemes.contains { scheme in
            guard let url = URL(string: "\(scheme)://") else {
                return false
            }
            return environment.canOpen(url)
        }
    }

    private func hasSuspiciousFile() -> Bool {
        return suspiciousPaths.contains(where: environment.fileExists)
    }

    private func hasSuspiciousDirectory() -> Bool {
        return suspiciousDirectories.contains { path in
            environment.contentsOfDirectory(atPath: path) != nil
        }
    }

    private func hasSuspiciousApplication() -> Bool {
        return applicationDirectories.contains { path in
            guard let entries = environment.contentsOfDirectory(atPath: path) else {
                return false
            }
            let normalizedEntries = Set(entries.map { $0.lowercased() })
            return !normalizedEntries.isDisjoint(with: suspiciousApplicationNames)
        }
    }

    private func hasSuspiciousDirectoryEntry() -> Bool {
        return suspiciousDirectoryEntries.contains { path, suspiciousEntries in
            guard let entries = environment.contentsOfDirectory(atPath: path) else {
                return false
            }
            let normalizedEntries = Set(entries.map { $0.lowercased() })
            return !normalizedEntries.isDisjoint(with: suspiciousEntries)
        }
    }

    private let suspiciousEnvironmentKeys: Set<String> = [
        "frida",
        "_mssafemode"
    ]

    private let fridaLocalPorts: Set<UInt16> = [27_042, 27_043]

    private let suspiciousImageTokens = [
        "frida",
        "cynject",
        "cycript",
        "substrate",
        "substitute",
        "libhooker",
        "ellekit",
        "tweakinject"
    ]

    private let suspiciousURLSchemes = [
        "cydia",
        "sileo",
        "zbra",
        "filza",
        "activator",
        "undecimus"
    ]

    private let applicationDirectories = [
        "/Applications",
        "/var/jb/Applications",
        "/private/var/jb/Applications"
    ]

    private let suspiciousApplicationNames: Set<String> = [
        "cydia.app",
        "sileo.app",
        "zebra.app",
        "filza.app",
        "palera1n.app",
        "blackra1n.app",
        "fakecarrier.app",
        "icy.app",
        "intelliscreen.app",
        "mxtube.app",
        "rockapp.app",
        "sbsettings.app",
        "winterboard.app"
    ]

    private let suspiciousDirectories = [
        "/var/jb",
        "/private/var/jb",
        "/Library/MobileSubstrate/DynamicLibraries",
        "/var/jb/Library/MobileSubstrate/DynamicLibraries",
        "/private/var/jb/Library/MobileSubstrate/DynamicLibraries",
        "/usr/lib/TweakInject",
        "/var/jb/usr/lib/TweakInject",
        "/usr/lib/frida",
        "/var/jb/usr/lib/frida"
    ]

    private let suspiciousDirectoryEntries: [String: Set<String>] = [
        "/usr/sbin": ["frida-server", "sshd"],
        "/var/jb/usr/sbin": ["frida-server", "sshd"],
        "/private/var/jb/usr/sbin": ["frida-server", "sshd"],
        "/Library/LaunchDaemons": ["re.frida.server.plist"],
        "/var/jb/Library/LaunchDaemons": ["re.frida.server.plist"],
        "/usr/lib": ["libhooker.dylib", "libsubstitute.dylib"]
    ]

    private let suspiciousPaths = [
        "/Applications/Cydia.app",
        "/Applications/Sileo.app",
        "/Applications/Zebra.app",
        "/Applications/Filza.app",
        "/Applications/palera1n.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/Library/LaunchDaemons/re.frida.server.plist",
        "/private/var/lib/apt",
        "/private/var/lib/cydia",
        "/private/var/mobile/Library/SBSettings/Themes",
        "/private/var/stash",
        "/private/var/tmp/cydia.log",
        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/usr/bin/sshd",
        "/usr/lib/libhooker.dylib",
        "/usr/lib/libsubstitute.dylib",
        "/usr/libexec/sftp-server",
        "/usr/sbin/frida-server",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/bin/bash",
        "/.bootstrapped_electra",
        "/.installed_unc0ver"
    ]
}

final class LiveJailbreakDetectionEnvironment: JailbreakDetectionEnvironment {
    var processEnvironment: [String: String] {
        return ProcessInfo.processInfo.environment
    }

    func canOpen(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }

    func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    func contentsOfDirectory(atPath path: String) -> [String]? {
        return try? FileManager.default.contentsOfDirectory(atPath: path)
    }

    func canWriteOutsideSandbox() -> Bool {
        let path = "/private/device-security-detect-\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)

        do {
            try Data("DeviceSecurityDetect".utf8).write(to: url, options: .atomic)
            try? FileManager.default.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }

    func canConnectToLocalPort(_ port: UInt16) -> Bool {
        let socketDescriptor = socket(AF_INET, SOCK_STREAM, 0)
        guard socketDescriptor >= 0 else {
            return false
        }
        defer { close(socketDescriptor) }

        var timeout = timeval(tv_sec: 0, tv_usec: 50_000)
        setsockopt(
            socketDescriptor,
            SOL_SOCKET,
            SO_SNDTIMEO,
            &timeout,
            socklen_t(MemoryLayout<timeval>.size)
        )

        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        address.sin_port = port.bigEndian
        address.sin_addr = in_addr(s_addr: inet_addr("127.0.0.1"))

        return withUnsafePointer(to: &address) { pointer in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) { socketAddress in
                connect(socketDescriptor, socketAddress, socklen_t(MemoryLayout<sockaddr_in>.size)) == 0
            }
        }
    }

    func loadedImageIdentifiers() -> [String] {
        return DyldImageInspector.loadedImageIdentifiers()
    }
}

enum DyldImageInspector {
    private static let machHeader32Magic: UInt32 = 0xfeedface
    private static let machHeader64Magic: UInt32 = 0xfeedfacf
    private static let dylibLoadCommands: Set<UInt32> = [
        0x0c, // LC_LOAD_DYLIB
        0x0d, // LC_ID_DYLIB
        0x18, // LC_LOAD_WEAK_DYLIB
        0x1f, // LC_REEXPORT_DYLIB
        0x20, // LC_LAZY_LOAD_DYLIB
        0x23 // LC_LOAD_UPWARD_DYLIB
    ]
    private static let requiredByDyldFlag: UInt32 = 0x80000000

    static func loadedImageIdentifiers() -> [String] {
        var identifiers: [String] = []

        for imageIndex in 0..<_dyld_image_count() {
            guard let header = _dyld_get_image_header(imageIndex) else {
                continue
            }
            identifiers.append(contentsOf: dylibIdentifiers(in: UnsafeRawPointer(header)))
        }

        return identifiers
    }

    static func dylibIdentifiers(in header: UnsafeRawPointer) -> [String] {
        let magic = header.load(as: UInt32.self)
        let headerSize: Int

        switch magic {
        case machHeader32Magic:
            headerSize = 28
        case machHeader64Magic:
            headerSize = 32
        default:
            return []
        }

        let numberOfCommands = Int(header.load(fromByteOffset: 16, as: UInt32.self))
        let commandsSize = Int(header.load(fromByteOffset: 20, as: UInt32.self))
        guard numberOfCommands <= 4_096, commandsSize <= 64 * 1_024 * 1_024 else {
            return []
        }

        var identifiers: [String] = []
        var commandOffset = headerSize
        let commandsEnd = headerSize + commandsSize

        for _ in 0..<numberOfCommands {
            guard commandOffset + 8 <= commandsEnd else {
                break
            }

            let command = header.advanced(by: commandOffset)
            let commandType = command.load(as: UInt32.self) & ~requiredByDyldFlag
            let commandSize = Int(command.load(fromByteOffset: 4, as: UInt32.self))
            guard commandSize >= 8, commandOffset + commandSize <= commandsEnd else {
                break
            }

            if dylibLoadCommands.contains(commandType), commandSize >= 12 {
                let nameOffset = Int(command.load(fromByteOffset: 8, as: UInt32.self))
                if let identifier = nullTerminatedString(
                    from: command,
                    offset: nameOffset,
                    upperBound: commandSize
                ) {
                    identifiers.append(identifier)
                }
            }

            commandOffset += commandSize
        }

        return identifiers
    }

    private static func nullTerminatedString(
        from baseAddress: UnsafeRawPointer,
        offset: Int,
        upperBound: Int
    ) -> String? {
        guard offset >= 0, offset < upperBound else {
            return nil
        }

        let buffer = UnsafeRawBufferPointer(
            start: baseAddress.advanced(by: offset),
            count: upperBound - offset
        )
        guard let stringEnd = buffer.firstIndex(of: 0), stringEnd > 0 else {
            return nil
        }

        return String(decoding: buffer[..<stringEnd], as: UTF8.self)
    }
}
