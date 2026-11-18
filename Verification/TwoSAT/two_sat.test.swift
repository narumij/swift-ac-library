// verification-helper: PROBLEM https://judge.yosupo.jp/problem/two_sat
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    _ = input.token() // p
    _ = input.token() // cnf
    let n = input.int(), m = input.int()
    var graph = AtCoder.TwoSAT(n)
    for _ in 0..<m {
      let a = input.int(), b = input.int()
      _ = input.int() // clause terminator
      graph.add_clause(abs(a) - 1, a > 0, abs(b) - 1, b > 0)
    }
    if graph.satisfiable() {
      fastPrint("s SATISFIABLE")
      fastPrint("v", terminator: 32)
      for (i, value) in graph.answer().enumerated() {
        fastPrint(value ? i + 1 : -(i + 1), terminator: 32)
      }
      fastPrint(0)
    } else {
      fastPrint("s UNSATISFIABLE")
    }
  }
}
