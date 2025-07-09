import Algorithms
import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

// time manager
private struct time_manager {
  var v: [Int]
  init(_ n: Int) {
    v = [Int](repeating: -1, count: n)
  }
  mutating func action(_ l: Int, _ r: Int, _ time: Int) {
    for i in l..<r {
      v[i] = time
    }
  }
  func prod(_ l: Int, _ r: Int) -> Int {
    var res = -1
    for i in l..<r {
      res = max(res, v[i])
    }
    return res
  }
}

private struct S {
  internal init(_ l: Int, _ r: Int, _ time: Int) {
    self.l = l
    self.r = r
    self.time = time
  }
  var l, r, time: Int
}
private struct T {
  internal init(_ new_time: Int) {
    self.new_time = new_time
  }
  var new_time: Int
}
private func op_ss(_ l: S, _ r: S) -> S {
  if l.l == -1 { return r }
  if r.l == -1 { return l }
  assert(l.r == r.l)
  return S(l.l, r.r, max(l.time, r.time))
}
private func op_ts(_ l: T, _ r: S) -> S {
  if l.new_time == -1 { return r }
  assert(r.time < l.new_time)
  return S(r.l, r.r, l.new_time)
}
private func op_tt(_ l: T, _ r: T) -> T {
  if l.new_time == -1 { return r }
  if r.new_time == -1 { return l }
  assert(l.new_time > r.new_time)
  return l
}
private func e_s() -> S { return S(-1, -1, -1) }
private func e_t() -> T { return T(-1) }

private enum param: ___LazySegTreeOperation {
  typealias S = AtCoderTests.S
  typealias F = AtCoderTests.T

  nonisolated(unsafe) static let op: Op = op_ss
  static let e: S = e_s()
  nonisolated(unsafe) static let mapping: Mapping = op_ts
  nonisolated(unsafe) static let composition: Composition = op_tt
  static let id: F = e_t()
}

private typealias seg = LazySegTree<param>

final class lazySegtreeStressTests: XCTestCase {

  #if DEBUG
    let (naive, right, left) = (300, 100, 100)
  #else
    let (naive, right, left) = (3000, 1000, 1000)
  #endif

  func testStressNaive() throws {
    self.measure {
      for n in 1 ..<= 30 {
        for _ in 0..<10 {
          var seg0 = seg(n)
          var tm = time_manager(n)
          for i in 0..<n {
            seg0.set(i, S(i, i + 1, -1))
          }
          var now = 0
          for _ in 0..<naive {
            let ty = randint(0, 3)
            var l: Int
            var r: Int
            (l, r) = randpair(0, n)
            if ty == 0 {
              let res = seg0.prod(l, r)
              XCTAssertEqual(l, res.l, "test 0")
              XCTAssertEqual(r, res.r, "test 1")
              XCTAssertEqual(tm.prod(l, r), res.time, "test 2")
            } else if ty == 1 {
              let res = seg0.get(l)
              XCTAssertEqual(l, res.l, "test 3")
              XCTAssertEqual(l + 1, res.r, "test 4")
              XCTAssertEqual(tm.prod(l, l + 1), res.time, "test 5")
            } else if ty == 2 {
              now += 1
              seg0.apply(l, r, T(now))
              tm.action(l, r, now)
            } else if ty == 3 {
              now += 1
              seg0.apply(l, T(now))
              tm.action(l, l + 1, now)
            } else {
              assert(false)
            }
          }
        }
      }
    }
  }

  func testStressMaxRight() throws {
    self.measure {
      for n in 1 ..<= 30 {
        for _ in 0..<10 {
          var seg0 = seg(n)
          var tm = time_manager(n)
          for i in 0..<n {
            seg0.set(i, S(i, i + 1, -1))
          }
          var now = 0
          for _ in 0..<right {
            let ty = randint(0, 2)
            var l: Int
            var r: Int
            (l, r) = randpair(0, n)
            if ty == 0 {
              XCTAssertEqual(
                r,
                seg0.max_right(l) { s in
                  if s.l == -1 { return true }
                  assert(s.l == l)
                  assert(s.time == tm.prod(l, s.r))
                  return s.r <= r
                })
            } else {
              now += 1
              seg0.apply(l, r, T(now))
              tm.action(l, r, now)
            }
          }
        }
      }
    }
  }

  func testStressMinLeft() throws {
    self.measure {
      for n in 1 ..<= 30 {
        for _ in 0..<10 {
          var seg0 = seg(n)
          var tm = time_manager(n)
          for i in 0..<n {
            seg0.set(i, S(i, i + 1, -1))
          }
          var now = 0
          for _ in 0..<left {
            let ty = randint(0, 2)
            var l: Int
            var r: Int
            (l, r) = randpair(0, n)
            if ty == 0 {
              XCTAssertEqual(
                l,
                seg0.min_left(r) { s in
                  if s.l == -1 { return true }
                  assert(s.r == r)
                  assert(s.time == tm.prod(s.l, r))
                  return l <= s.l
                })
            } else {
              now += 1
              seg0.apply(l, r, T(now))
              tm.action(l, r, now)
            }
          }
        }
      }
    }
  }
}
