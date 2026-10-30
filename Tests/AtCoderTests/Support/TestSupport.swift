import Testing

// Product caches and dynamic modulus are shared across suites.
// Preserve the sequential XCTest execution model during framework migration.
@Suite(.serialized)
enum LibraryTests {}

// XCTest measure used ten iterations without a stored performance baseline.
// Retain that workload and report elapsed time; this is not a timing assertion.
func measureRepeated(_ body: () -> Void) {
  let clock = ContinuousClock()
  let duration = clock.measure {
    for _ in 0..<10 { body() }
  }
  print("Ten iterations: \(duration)")
}

// Origin is independent of execution policy and performance measurement.
extension Tag {
  @Tag static var aclPort: Self
  @Tag static var swiftSpecific: Self
  @Tag static var exitTest: Self
}
