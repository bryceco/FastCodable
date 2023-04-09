// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FastCodable",
    products: [
        .library(
            name: "FastCodable",
            targets: ["FastCodable"]
		),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FastCodable",
            dependencies: []
		),
        .testTarget(
            name: "FastCodableTests",
            dependencies: ["FastCodable"]
		),
    ]
)
