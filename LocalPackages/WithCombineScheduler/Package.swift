// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// Any version. Actual version of a dependency can be found in Package.locked
let anyVersion = Version(0, 0, 1)...Version(999, 0, 0)

let package = Package(
    name: "WithCombineScheduler",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WithCombineScheduler",
            targets: ["WithCombineScheduler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/combine-schedulers.git", anyVersion)
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WithCombineScheduler",
            dependencies: [
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]),
        .testTarget(
            name: "WithCombineSchedulerTests",
            dependencies: ["WithCombineScheduler"]),
    ]
)
