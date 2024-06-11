// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BridgewellSDK",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "BridgewellFramework",
            targets: ["BridgewellFramework"]
        ),
        .library(
            name: "PrebidMobile",
            targets: ["PrebidMobile"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "BridgewellFramework",
            path: "./BridgewellSDK/BridgewellSDK.xcframework"
        ),
        .binaryTarget(
            name: "PrebidMobile",
            path: "./PrebidFrameworks/XCPrebidMobile.xcframework"
        ),
    ]
)
