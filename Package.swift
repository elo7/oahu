// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Oahu",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "Oahu",
            targets: ["Oahu"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Oahu",
            dependencies: []),
        .testTarget(
            name: "OahuTests",
            dependencies: ["Oahu"]),
    ],
    swiftLanguageVersions: [.v5]
)
