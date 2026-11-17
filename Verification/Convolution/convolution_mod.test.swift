// verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod
import AtCoder
import VerificationIO

@main
struct Convolution {
  static func main() {
    var input = Input()
    let n = input.int(), m = input.int()
    let a = (0..<n).map { _ in input.int() }
    let b = (0..<m).map { _ in input.int() }
    let result = convolution(mod_998_244_353.self, a, b)
    writeOutput(result.map(String.init).joined(separator: " ") + "\n")
  }
}
