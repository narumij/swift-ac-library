struct Buffer: ~Copyable {
  let pointer: UnsafeMutablePointer<Int>
  let count: Int

  var values: UnsafeMutableBufferPointer<Int> {
    .init(start: pointer, count: count)
  }

  mutating func add(_ a: Int, _ b: Int) {
    values[a] += values[b]
  }
}
