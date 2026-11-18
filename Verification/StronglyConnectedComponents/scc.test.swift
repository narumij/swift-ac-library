// verification-helper: PROBLEM https://judge.yosupo.jp/problem/scc
import AtCoder
import VerificationIO

@main
struct StronglyConnectedComponents {
  static func main() {
    var input = Input()
    let n = input.int(), m = input.int()
    var graph = SCCGraph(n)
    for _ in 0..<m {
      let from = input.int(), to = input.int()
      graph.add_edge(from, to)
    }
    let groups = graph.scc()
    fastPrint(groups.count)
    for group in groups {
      fastPrint(group.count, terminator: 32)
      printValues(group)
    }
  }
}
