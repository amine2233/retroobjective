// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RetroObjective",
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RetroObjectiveObjC",
            targets: ["RetroObjectiveObjC"]),
        .library(
            name: "RetroObjective",
            targets: ["RetroObjective"]),
        .library(
            name: "RetroObjectiveCombine",
            targets: ["RetroObjectiveCombine"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "RetroObjectiveObjC",
            path: "Sources/RetroObjectiveObjC",
            publicHeadersPath: ""
        ),
        .target(
            name: "RetroObjective",
            dependencies: [
                .target(name: "RetroObjectiveObjC")
            ]),
        .target(
            name: "RetroObjectiveCombine",
            dependencies: [
                .target(name: "RetroObjective")
            ]),
        .testTarget(
            name: "RetroObjectiveTests",
            dependencies: [
                .target(name: "RetroObjective")
            ]),
        .testTarget(
            name: "RetroObjectiveCombineTests",
            dependencies: [
            .target(name: "RetroObjectiveCombine")
        ])
    ]
)
