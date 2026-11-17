// verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_composite
import AtCoder
import VerificationIO

typealias Mint = modint998244353

enum Composition: SegTreeOperator {
  struct S { var a: Mint; var b: Mint }
  static var e: S { S(a: 1, b: 0) }
  // The right segment acts after the left segment.
  static func op(_ l: S, _ r: S) -> S {
    S(a: r.a * l.a, b: r.a * l.b + r.b)
  }
}

@main
struct Solution {
  static func main() {
    var input = Input()
    let n = input.int(), q = input.int()
    let values = (0..<n).map { _ in Composition.S(a: Mint(input.int()), b: Mint(input.int())) }
    var tree = SegTree<Composition>(values)
    for _ in 0..<q {
      let t = input.int()
      if t == 0 {
        let p = input.int(), a = input.int(), b = input.int()
        tree.set(p, Composition.S(a: Mint(a), b: Mint(b)))
      } else {
        let l = input.int(), r = input.int(), x = input.int()
        let f = tree.prod(l, r)
        print((f.a * Mint(x) + f.b).val)
      }
    }
  }
}
