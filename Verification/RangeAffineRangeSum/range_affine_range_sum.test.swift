// verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum
import AtCoder
import VerificationIO

typealias Mint = modint998244353

enum AffineSum: LazySegTreeOperator {
  struct S { var sum: Mint; var count: Int }
  struct F { var a: Mint; var b: Mint }
  static var e: S { S(sum: 0, count: 0) }
  static var id: F { F(a: 1, b: 0) }
  static func op(_ x: S, _ y: S) -> S {
    S(sum: x.sum + y.sum, count: x.count + y.count)
  }
  static func mapping(_ f: F, _ x: S) -> S {
    S(sum: f.a * x.sum + f.b * Mint(x.count), count: x.count)
  }
  // composition(f, g) applies g first, then f.
  static func composition(_ f: F, _ g: F) -> F {
    F(a: f.a * g.a, b: f.a * g.b + f.b)
  }
}

@main
struct RangeAffineRangeSum {
  static func main() {
    var input = Input()
    let n = input.int(), q = input.int()
    let values = (0..<n).map { _ in AffineSum.S(sum: Mint(input.int()), count: 1) }
    var tree = LazySegTree<AffineSum>(values)
    for _ in 0..<q {
      let t = input.int(), l = input.int(), r = input.int()
      if t == 0 {
        let b = input.int(), c = input.int()
        tree.apply(l, r, AffineSum.F(a: Mint(b), b: Mint(c)))
      } else {
        fastPrint(tree.prod(l, r).sum.val)
      }
    }
  }
}
