// verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    let s = input.token()
    printValues(z_algorithm(s))
  }
}
