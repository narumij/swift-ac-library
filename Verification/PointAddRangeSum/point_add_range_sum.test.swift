// verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
import AtCoder
import VerificationIO

@main
struct PointAddRangeSum {
  static func main() {
    var input = Input()
    let n = input.int(), q = input.int()
    var tree = FenwickTree<Int>(n)
    for i in 0..<n { tree.add(i, input.int()) }
    for _ in 0..<q {
      let t = input.int(), a = input.int(), b = input.int()
      if t == 0 { tree.add(a, b) }
      else { fastPrint(tree.sum(a, b)) }
    }
  }
}
