// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiniFlawless",
    platforms: [ .iOS(.v12) ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MiniFlawless",
            targets: ["MiniFlawless"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MiniFlawless",
            dependencies: [],
            path: "Sources",
            exclude: [
                "Supporting Files/Info.plist",
                "Supporting Files/MiniFlawless.h",
                "Sources/Item List/MiniFlawlessItemList.swift",
                "Sources/Item List/MiniFlawlessItemList+ItemLink.swift",
                "Sources/Item List/MiniFlawlessItemList+FromTo.swift",
                "Sources/Manager/MiniFlawlessManager.swift",
                "Sources/Manager/MiniFlawlessAnimatorGroup.swift",
                "Sources/Extensions/SwiftBool+MiniFlawless.swift"
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [ .iOS  ])),
                .linkedFramework("QuartzCore", .when(platforms: [ .iOS  ])),
                .linkedFramework("CoreGraphics", .when(platforms: [ .iOS ]))
            ]
        ),
        .testTarget(
            name: "MiniFlawlessTests",
            dependencies: ["MiniFlawless"],
            path: "Tests",
            exclude: [
                "Supporting Files/Info.plist"
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
