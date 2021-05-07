// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetworkStack",
  platforms: [.iOS(.v11)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "NetworkStack",
      targets: ["NetworkStack"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.1.0")),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
      .exact("4.2.0"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "NetworkStack",
      dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift"),
                     "Alamofire", "KeychainAccess"]),
    .testTarget(
      name: "NetworkStackTests",
      dependencies: ["NetworkStack"]),
    
  ],
  swiftLanguageVersions: [.v4, .v4_2, .v5]
)
