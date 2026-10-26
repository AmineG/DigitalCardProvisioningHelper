// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "DigitalCardProvisioningHelper",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DigitalCardProvisioningHelper",
            targets: ["DigitalCardProvisioningHelper"]
        )
    ],
    targets: [
        .target(
            name: "DigitalCardProvisioningHelper",
        ),
        .testTarget(
            name: "DigitalCardProvisioningHelperTests",
            dependencies: ["DigitalCardProvisioningHelper"],
        )
    ]
)
