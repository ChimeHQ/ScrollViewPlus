// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "ScrollViewPlus",
	platforms: [.macOS(.v10_13)],
	products: [
		.library(name: "ScrollViewPlus", targets: ["ScrollViewPlus"]),
	],
	dependencies: [],
	targets: [
		.target(name: "ScrollViewPlus", dependencies: [], path: "ScrollViewPlus/"),
		.testTarget(name: "ScrollViewPlusTests", dependencies: ["ScrollViewPlus"], path: "ScrollViewPlusTests/"),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
	.enableUpcomingFeature("DisableOutwardActorInference"),
	.enableUpcomingFeature("IsolatedDefaultValues"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
