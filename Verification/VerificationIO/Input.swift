import Foundation

// Input is assumed to satisfy the selected Library Checker problem's contract.
public struct Input {
  private var bytes = Array(FileHandle.standardInput.readDataToEndOfFile()) + [0]
  private var index = 0

  public init() {}

  private mutating func skipWhitespace() {
    while bytes[index] == 10 || bytes[index] == 13 || bytes[index] == 32 || bytes[index] == 9 {
      index += 1
    }
  }

  public mutating func int() -> Int {
    skipWhitespace()
    let negative = bytes[index] == 45
    if negative { index += 1 }
    var value = 0
    while bytes[index] >= 48 && bytes[index] <= 57 {
      value = value * 10 + Int(bytes[index] - 48)
      index += 1
    }
    return negative ? -value : value
  }

  public mutating func token() -> [UInt8] {
    skipWhitespace()
    let start = index
    while bytes[index] > 32 { index += 1 }
    return Array(bytes[start..<index])
  }
}

// Print a computed sequence without making an output string or a second array.
public func printValues<S: Sequence>(_ values: S) {
  var separator = ""
  for value in values {
    Swift.print(separator, terminator: "")
    Swift.print(value, terminator: "")
    separator = " "
  }
  Swift.print()
}
