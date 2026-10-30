import Testing

// Product caches and dynamic modulus are shared across suites.
// Preserve the sequential XCTest execution model during framework migration.
@Suite(.serialized)
enum LibraryTests {}

// XCTest measure used ten iterations without a stored performance baseline.
// Usually retain that workload; this is not a timing assertion.
// ASan checks memory safety rather than performance: execute every body once,
// preserving its input sizes, inner stress loops and assertions.
func measureRepeated(_ body: () -> Void) {
  #if ASAN_TEST
    let iterations = 1
  #else
    let iterations = 10
  #endif
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
