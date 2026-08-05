import XCTest
@testable import DeviceSecurityDetectPlugin

class DeviceSecurityDetectTests: XCTestCase {
    func testCleanEnvironmentIsNotReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()

        XCTAssertFalse(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testSuspiciousLoadedImageIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.imageIdentifiers = ["/usr/lib/frida/frida-agent.dylib"]

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testFridaDefaultLocalEndpointIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.openLocalPorts = [27_042]

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testFridaFallbackLocalEndpointIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.openLocalPorts = [27_043]

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testUnrelatedLocalEndpointIsNotReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.openLocalPorts = [27_044]

        XCTAssertFalse(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testReadableRootlessJailbreakDirectoryIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.directoryContents["/var/jb"] = []

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testJailbreakApplicationFoundByDirectoryEnumerationIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.directoryContents["/Applications"] = ["MobileSafari.app", "Sileo.app"]

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testFridaServerFoundByDirectoryEnumerationIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.directoryContents["/usr/sbin"] = ["frida-server"]

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testWritablePathOutsideSandboxIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.isOutsideSandboxWritable = true

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testInjectedDynamicLibraryEnvironmentIsReportedAsJailbroken() {
        let environment = StubJailbreakDetectionEnvironment()
        environment.variables["DYLD_INSERT_LIBRARIES"] = "/tmp/frida-agent.dylib"

        XCTAssertTrue(JailbreakDetector(environment: environment).isJailbroken())
    }

    func testDylibIdentifierIsReadDirectlyFromMachHeader() {
        let identifier = "/usr/lib/frida/frida-agent.dylib"
        let identifierBytes = Array(identifier.utf8) + [0]
        let commandSize = 24 + identifierBytes.count
        let headerSize = 32
        let memory = UnsafeMutableRawPointer.allocate(
            byteCount: headerSize + commandSize,
            alignment: 8
        )
        defer { memory.deallocate() }
        memory.initializeMemory(as: UInt8.self, repeating: 0, count: headerSize + commandSize)

        memory.storeBytes(of: UInt32(0xfeedfacf), as: UInt32.self)
        memory.storeBytes(of: UInt32(1), toByteOffset: 16, as: UInt32.self)
        memory.storeBytes(of: UInt32(commandSize), toByteOffset: 20, as: UInt32.self)
        memory.storeBytes(of: UInt32(0x0d), toByteOffset: headerSize, as: UInt32.self)
        memory.storeBytes(of: UInt32(commandSize), toByteOffset: headerSize + 4, as: UInt32.self)
        memory.storeBytes(of: UInt32(24), toByteOffset: headerSize + 8, as: UInt32.self)
        identifierBytes.withUnsafeBytes { bytes in
            guard let baseAddress = bytes.baseAddress else {
                return
            }
            memory.advanced(by: headerSize + 24).copyMemory(
                from: baseAddress,
                byteCount: bytes.count
            )
        }

        XCTAssertEqual(DyldImageInspector.dylibIdentifiers(in: memory), [identifier])
    }
}

private final class StubJailbreakDetectionEnvironment: JailbreakDetectionEnvironment {
    var openableSchemes: Set<String> = []
    var existingPaths: Set<String> = []
    var directoryContents: [String: [String]] = [:]
    var isOutsideSandboxWritable = false
    var imageIdentifiers: [String] = []
    var openLocalPorts: Set<UInt16> = []
    var variables: [String: String] = [:]

    var processEnvironment: [String: String] {
        return variables
    }

    func canOpen(_ url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        return openableSchemes.contains(scheme)
    }

    func fileExists(atPath path: String) -> Bool {
        return existingPaths.contains(path)
    }

    func contentsOfDirectory(atPath path: String) -> [String]? {
        return directoryContents[path]
    }

    func canWriteOutsideSandbox() -> Bool {
        return isOutsideSandboxWritable
    }

    func loadedImageIdentifiers() -> [String] {
        return imageIdentifiers
    }

    func canConnectToLocalPort(_ port: UInt16) -> Bool {
        return openLocalPorts.contains(port)
    }
}
