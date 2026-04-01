// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComputeDHT",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ComputeDHT",
            targets: ["ComputeDHT"]
        ),
        .library(
            name: "OverlayFundation",
            targets: ["OverlayFundation"]
        ),
        .library(
            name: "OverlayDHT",
            targets: ["OverlayDHT"]
        ),
        .library(
            name: "CoreOverlay",
            targets: ["CoreOverlay"]
        ),
        .executable(
            name: "cot",
            targets: ["CLI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.7.1"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.20")),
    ],
    targets: [
        .target(
            name: "ComputeDHT"
        ),
        .target(
            name: "CBreeze",
            exclude: ["README.md"]
        ),
        .target(
            name: "OverlayFundation"
        ),
        .target(
            name: "OverlayDHT"
        ),
        .target(
            name: "CoreOverlay",
            dependencies: [
                "OverlayFundation",
                "OverlayDHT",
                "CBreeze",
            ]
        ),
        .executableTarget(
            name: "CLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ]
        ),
        .testTarget(
            name: "ComputeDHTTests",
            dependencies: ["ComputeDHT"]
        ),
        .testTarget(
            name: "CoreOverlayTests",
            dependencies: [
                "CoreOverlay",
                "OverlayFundation",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
