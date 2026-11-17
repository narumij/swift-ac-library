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
      print("s SATISFIABLE")
      print("v", terminator: " ")
      for (i, value) in graph.answer().enumerated() {
        print(value ? i + 1 : -(i + 1), terminator: " ")
      }
      print(0)
    } else {
      print("s UNSATISFIABLE")
    }
  }
}
