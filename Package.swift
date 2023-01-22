// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "books-export-cli",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.14.1"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.9.0")
        
    ],
    targets: [
        .executableTarget(
            name: "books-export-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "SwiftyTextTable", package: "SwiftyTextTable"),
            ]
        ),
        .testTarget(
            name: "books-export-cliTests",
            dependencies: ["books-export-cli"]),
    ]
)
