// verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind
import AtCoder
import Foundation

// Library Checker supplies nonnegative integers separated by ASCII whitespace.
struct Input {
  var bytes = Array(FileHandle.standardInput.readDataToEndOfFile()) + [0]
  var index = 0

  mutating func int() -> Int {
    while bytes[index] == 10 || bytes[index] == 13 || bytes[index] == 32 {
      index += 1
    }
    var value = 0
    while bytes[index] >= 48 && bytes[index] <= 57 {
      value = value * 10 + Int(bytes[index] - 48)
      index += 1
    }
    return value
  }
}

@main
struct UnionFind {
  static func main() {
    var input = Input()
    let n = input.int()
    let q = input.int()
    var dsu = DSU(n)
    var output = String()
    output.reserveCapacity(q * 2)
    for _ in 0..<q {
      let t = input.int()
      let u = input.int()
      let v = input.int()
      if t == 0 {
        _ = dsu.merge(u, v)
      } else {
        output += dsu.same(u, v) ? "1\n" : "0\n"
      }
    }
    FileHandle.standardOutput.write(Data(output.utf8))
  }
}
