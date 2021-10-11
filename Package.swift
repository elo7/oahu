// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "oahu",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "oahu",
            targets: ["oahu"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "oahu",
            dependencies: []),
        .testTarget(
            name: "oahuTests",
            dependencies: ["oahu"]),
    ],
    swiftLanguageVersions: [.v5]
)
