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
      revision: "a596b4338a59e8b0a32dcf66eba611bc0ceef48d"
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
