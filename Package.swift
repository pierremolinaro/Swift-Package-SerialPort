// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//--------------------------------------------------------------------------------------------------

import PackageDescription

//--------------------------------------------------------------------------------------------------

let package = Package (
  name: "SerialPort",
  platforms: [.macOS (.v15)],
  products: [
    .library (name: "SerialPort", targets: ["SerialPort"])
  ],
  dependencies: [
    .package (
      url: "https://github.com/pierremolinaro/Swift-Package-BinarySerialFormat",
      revision: "a6c94e5813c1d02cbf70215327bf8941075031c3"
    )
  ],
  targets: [
    .target (
      name: "SerialPort",
      dependencies: [
        .product (name: "BinarySerialFormat", package: "Swift-Package-BinarySerialFormat")
      ]
    )
  ],
  swiftLanguageModes: [.v6]
)

//--------------------------------------------------------------------------------------------------
