import AppKit
import Carbon
import CoreLocation
import CoreWLAN
import Darwin
import Foundation

let cacheDirectory = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Caches/local.sketchybar.StatusHelper", isDirectory: true)

func writeCache(_ value: String, name: String) {
    do {
        try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true,
                                                 attributes: [.posixPermissions: 0o700])
        let file = cacheDirectory.appendingPathComponent(name)
        try value.write(to: file, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: file.path)
    } catch { exit(1) }
}

final class LocationRequest: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var authorizationObserved = false
    var location: CLLocation?
    var finished = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationObserved = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        finished = true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finished = true
    }
}

func waitForAuthorization(_ request: LocationRequest) {
    let deadline = Date().addingTimeInterval(3)
    while !request.authorizationObserved && Date() < deadline {
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
    }
}

func authorized(_ status: CLAuthorizationStatus) -> Bool {
    status == .authorizedAlways
}

struct Monitor: Decodable {
    let monitorID: Int
    let monitorName: String
    enum CodingKeys: String, CodingKey {
        case monitorID = "monitor-id"
        case monitorName = "monitor-name"
    }
}

func run(_ path: String, _ arguments: [String]) -> String? {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: path)
    process.arguments = arguments
    let output = Pipe()
    process.standardOutput = output
    process.standardError = FileHandle.nullDevice
    do {
        try process.run()
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else { return nil }
        return String(data: data, encoding: .utf8)
    } catch { return nil }
}

switch CommandLine.arguments.dropFirst().first ?? "" {
case "keyboard":
    guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
          let property = TISGetInputSourceProperty(source, kTISPropertyLocalizedName) else { exit(1) }
    let name = Unmanaged<CFString>.fromOpaque(property).takeUnretainedValue()
    print(name as String)
case "wifi":
    let request = LocationRequest()
    waitForAuthorization(request)
    if authorized(request.manager.authorizationStatus),
       let ssid = CWWiFiClient.shared().interface()?.ssid(), !ssid.isEmpty {
        writeCache(ssid, name: "wifi")
        print(ssid)
    } else {
        writeCache("unavailable", name: "wifi")
        print("unavailable")
    }
case "authorize":
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 360, height: 100),
                          styleMask: [.titled], backing: .buffered, defer: false)
    window.title = "SketchyBar Location Access"
    let message = NSTextField(labelWithString: "Allow location access to show Wi-Fi and local weather.")
    message.frame = NSRect(x: 20, y: 35, width: 320, height: 30)
    window.contentView?.addSubview(message)
    window.center()
    window.makeKeyAndOrderFront(nil)
    app.activate(ignoringOtherApps: true)
    let request = LocationRequest()
    waitForAuthorization(request)
    if request.manager.authorizationStatus == .notDetermined {
        request.manager.requestWhenInUseAuthorization()
        let deadline = Date().addingTimeInterval(60)
        while request.manager.authorizationStatus == .notDetermined && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
    }
    exit(authorized(request.manager.authorizationStatus) ? 0 : 1)
case "status":
    let request = LocationRequest()
    waitForAuthorization(request)
    let status = String(request.manager.authorizationStatus.rawValue)
    writeCache(status, name: "authorization")
    print(status)
case "location":
    let request = LocationRequest()
    waitForAuthorization(request)
    guard authorized(request.manager.authorizationStatus) else { exit(1) }
    request.manager.requestLocation()
    let deadline = Date().addingTimeInterval(12)
    while !request.finished && Date() < deadline {
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
    }
    guard let location = request.location, location.horizontalAccuracy >= 0,
          abs(location.timestamp.timeIntervalSinceNow) <= 1800,
          abs(location.coordinate.latitude) <= 90,
          abs(location.coordinate.longitude) <= 180 else { exit(1) }
    let coordinates = String(format: "%.2f,%.2f", locale: Locale(identifier: "en_US_POSIX"),
                             location.coordinate.latitude, location.coordinate.longitude)
    writeCache(coordinates, name: "location")
    print(coordinates)
case "cpu":
    var info = host_cpu_load_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info_data_t>.stride / MemoryLayout<integer_t>.stride)
    let result = withUnsafeMutablePointer(to: &info) { pointer in
        pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
        }
    }
    guard result == KERN_SUCCESS else { exit(1) }
    let ticks = info.cpu_ticks
    let busy = UInt64(ticks.0) + UInt64(ticks.1) + UInt64(ticks.3)
    let total = busy + UInt64(ticks.2)
    print("\(busy) \(total)")
case "displays":
    guard CommandLine.arguments.count > 2,
          let json = run(CommandLine.arguments[2], ["list-monitors", "--json"]),
          let data = json.data(using: .utf8),
          let monitors = try? JSONDecoder().decode([Monitor].self, from: data),
          let focusedJSON = run(CommandLine.arguments[2], ["list-monitors", "--focused", "--json"]),
          let focusedData = focusedJSON.data(using: .utf8),
          let focused = try? JSONDecoder().decode([Monitor].self, from: focusedData).first?.monitorID else { exit(1) }
    for monitor in monitors {
        print("\(monitor.monitorID)\t\(monitor.monitorName)\t\(monitor.monitorID == focused ? 1 : 0)")
    }
default:
    exit(2)
}
