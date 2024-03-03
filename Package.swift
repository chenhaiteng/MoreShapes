// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoreShapes",
    platforms: [.macOS(.v14), .iOS(.v14), .tvOS(.v13), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MoreShapes",
            targets: ["MoreShapes"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/chenhaiteng/CoreGraphicsExtension.git", from: "0.4.0"),
        .package(url: "https://github.com/chenhaiteng/GradientBuilder.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MoreShapes",
            dependencies: ["CoreGraphicsExtension", "GradientBuilder"]),
        .testTarget(
            name: "MoreShapesTests",
            dependencies: ["MoreShapes", "CoreGraphicsExtension", "GradientBuilder"]),
    ]
)
