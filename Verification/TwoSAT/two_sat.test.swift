// verification-helper: PROBLEM https://judge.yosupo.jp/problem/two_sat
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    precondition(input.token() == Array("p".utf8))
    precondition(input.token() == Array("cnf".utf8))
    let n = input.int(), m = input.int()
    var graph = AtCoder.TwoSAT(n)
    for _ in 0..<m {
      let a = input.int(), b = input.int()
      precondition(input.int() == 0)
      graph.add_clause(abs(a) - 1, a > 0, abs(b) - 1, b > 0)
    }
    if graph.satisfiable() {
      let values = graph.answer().enumerated().map { i, value in String(value ? i + 1 : -(i + 1)) }
      writeOutput("s SATISFIABLE\nv " + values.joined(separator: " ") + " 0\n")
    } else {
      writeOutput("s UNSATISFIABLE\n")
    }
  }
}
