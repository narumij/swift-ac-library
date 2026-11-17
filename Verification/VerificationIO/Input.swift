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
    var value = 0
    while bytes[index] >= 48 && bytes[index] <= 57 {
      value = value * 10 + Int(bytes[index] - 48)
      index += 1
    }
    return value
  }

  public mutating func token() -> [UInt8] {
    skipWhitespace()
    let start = index
    while bytes[index] > 32 { index += 1 }
    return Array(bytes[start..<index])
  }
}

public func writeOutput(_ text: String) {
  FileHandle.standardOutput.write(Data(text.utf8))
}
