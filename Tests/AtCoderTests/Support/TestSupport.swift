import Testing

// Product caches and dynamic modulus are shared across suites.
// Preserve the sequential XCTest execution model during framework migration.
@Suite(.serialized)
enum LibraryTests {}

// XCTest measure used ten iterations without a stored performance baseline.
// Usually retain that workload; this is not a timing assertion.
// ASan also runs all ten iterations; CI measures whether this workload is practical.
func measureRepeated(_ body: () -> Void) {
  let iterations = 10
  let clock = ContinuousClock()
  let duration = clock.measure {
    for _ in 0..<iterations { body() }
  }
  print("\(iterations) measurement iteration(s): \(duration)")
}

// Origin is independent of execution policy and performance measurement.
extension Tag {
  @Tag static var aclPort: Self
  @Tag static var swiftSpecific: Self
  @Tag static var exitTest: Self
}
