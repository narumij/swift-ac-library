// verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind
import AtCoder
import VerificationIO

@main
struct UnionFind {
  static func main() {
    var input = Input()
    let n = input.int()
    let q = input.int()
    var dsu = DSU(n)
    for _ in 0..<q {
      let t = input.int()
      let u = input.int()
      let v = input.int()
      if t == 0 {
        _ = dsu.merge(u, v)
      } else {
        print(dsu.same(u, v) ? 1 : 0)
      }
    }
  }
}
