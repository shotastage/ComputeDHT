// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComputeDHT",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ComputeDHT",
            targets: ["ComputeDHT"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/WasmKit.git", .upToNextMinor(from: "0.2.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ComputeDHT",
            dependencies: [.product(name: "WasmKit", package: "WasmKit")],
        ),
        .target(
            name: "CBreeze"
        ),
        .testTarget(
            name: "ComputeDHTTests",
            dependencies: ["ComputeDHT"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
