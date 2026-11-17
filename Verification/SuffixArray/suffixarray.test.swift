// verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    let s = input.token()
    writeOutput(suffix_array(s).map(String.init).joined(separator: " ") + "\n")
  }
}
