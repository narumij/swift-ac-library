// verification-helper: PROBLEM https://judge.yosupo.jp/problem/assignment
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    let n = input.int()
    let source = 2 * n, sink = source + 1
    // All solutions use n matrix edges, so a common shift preserves the optimum.
    let shift = 1_000_000_000
    var graph = MCFGraph<Int, Int>(count: sink + 1)
    for i in 0..<n {
      graph.add_edge(source, i, 1, 0)
      graph.add_edge(n + i, sink, 1, 0)
    }
    var edgeIDs: [Int] = []
    for i in 0..<n {
      for j in 0..<n {
        edgeIDs.append(graph.add_edge(i, n + j, 1, input.int() + shift))
      }
    }
    let (amount, cost) = graph.flow(source, sink, n)
    precondition(amount == n)
    var permutation = [Int](repeating: -1, count: n)
    for id in edgeIDs {
      let edge = graph.get_edge(id)
      if edge.flow == 1 { permutation[edge.from] = edge.to - n }
    }
    writeOutput("\(cost - n * shift)\n" + permutation.map(String.init).joined(separator: " ") + "\n")
  }
}
