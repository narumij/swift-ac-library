// verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    let l = input.int(), r = input.int(), m = input.int()
    let source = l + r, sink = source + 1
    var graph = MFGraph<Int>(count: sink + 1)
    for i in 0..<l { graph.add_edge(source, i, 1) }
    for i in 0..<r { graph.add_edge(l + i, sink, 1) }
    var edgeIDs: [Int] = []
    for _ in 0..<m {
      let u = input.int(), v = input.int()
      edgeIDs.append(graph.add_edge(u, l + v, 1))
    }
    let count = graph.flow(source, sink)
    fastPrint(count)
    for id in edgeIDs {
      let edge = graph.get_edge(id)
      if edge.flow == 1 { fastPrint(edge.from, terminator: 32); fastPrint(edge.to - l) }
    }
  }
}
