// verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import AtCoder
import VerificationIO

@main
struct NumberOfSubstrings {
  static func main() {
    var input = Input()
    let s = input.token()
    let sa = suffix_array(s)
    let lcp = lcp_array(s, sa)
    let result = s.count * (s.count + 1) / 2 - lcp.reduce(0, +)
    fastPrint(result)
  }
}
