// verification-helper: PROBLEM https://judge.yosupo.jp/problem/sum_of_floor_of_linear
import AtCoder
import VerificationIO

@main
struct SumOfFloorOfLinear {
  static func main() {
    var input = Input()
    let t = input.int()
    var output = ""
    for _ in 0..<t {
      let n = input.int(), m = input.int(), a = input.int(), b = input.int()
      output += "\(floor_sum(n, m, a, b))\n"
    }
    writeOutput(output)
  }
}
