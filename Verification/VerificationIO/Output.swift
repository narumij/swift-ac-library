import Foundation

// Submission helpers: write immediately through stdio, without output strings.
@inlinable
public func fastPrint<I: FixedWidthInteger>(_ value: I, terminator: Int32? = 10) {
  var magnitude = value.magnitude
  if value < 0 { putchar_unlocked(45) }
  withUnsafeTemporaryAllocation(of: UInt8.self, capacity: I.bitWidth) { digits in
    var count = 0
    repeat {
      digits[count] = UInt8(magnitude % 10) + 48
      magnitude /= 10
      count += 1
    } while magnitude != 0
    while count > 0 {
      count -= 1
      putchar_unlocked(Int32(digits[count]))
    }
  }
  if let terminator { putchar_unlocked(terminator) }
}

@inlinable
public func fastPrint(_ value: StaticString, terminator: Int32? = 10) {
  value.withUTF8Buffer { bytes in
    for byte in bytes { putchar_unlocked(Int32(byte)) }
  }
  if let terminator { putchar_unlocked(terminator) }
}

@inlinable
public func printValues<S: Sequence>(_ values: S) where S.Element: FixedWidthInteger {
  var first = true
  for value in values {
    if !first { putchar_unlocked(32) }
    fastPrint(value, terminator: nil)
    first = false
  }
  putchar_unlocked(10)
}
