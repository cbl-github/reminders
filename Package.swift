// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GurrReminders",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "GurrReminders", targets: ["GurrReminders"])
    ],
    targets: [
        .executableTarget(
            name: "GurrReminders",
            exclude: ["Resources/Info.plist"]
        )
    ]
)
