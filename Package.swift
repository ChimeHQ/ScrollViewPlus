// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "ScrollViewPlus",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.library(name: "ScrollViewPlus", targets: ["ScrollViewPlus"]),
	],
	dependencies: [],
	targets: [
		.target(name: "ScrollViewPlus", dependencies: [], path: "ScrollViewPlus/"),
		.testTarget(name: "ScrollViewPlusTests", dependencies: ["ScrollViewPlus"], path: "ScrollViewPlusTests/"),
	]
)
