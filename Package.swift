// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Anodize",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "Anodize", targets: ["Anodize"]),
        .library(
            name: "AnodizeUtil",
            targets: ["AnodizeUtil"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Anodize",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "AnodizeUtil")
    ]
)
