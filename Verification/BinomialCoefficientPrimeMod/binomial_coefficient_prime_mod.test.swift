// verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
import AtCoder
import VerificationIO


@main
struct Solution {
  static func main() {
    var input = Input()
    let t = input.int(), modulus = input.int()
    modint.set_mod(modulus)
    var queries: [(Int, Int)] = []
    var maximum = 0
    for _ in 0..<t {
      let n = input.int(), k = input.int()
      queries.append((n, k))
      maximum = max(maximum, n)
    }
    var factorial = [modint](repeating: 1, count: maximum + 1)
    if maximum > 0 {
      for i in 1...maximum { factorial[i] = factorial[i - 1] * modint(i) }
    }
    let inverse = inv_mod(Int(factorial[maximum].val), modulus)
    var inverseFactorial = [modint](repeating: 1, count: maximum + 1)
    inverseFactorial[maximum] = modint(inverse)
    if maximum > 0 {
      for i in stride(from: maximum, through: 1, by: -1) {
        inverseFactorial[i - 1] = inverseFactorial[i] * modint(i)
      }
    }
    for (n, k) in queries {
      let answer: modint = k > n ? 0 : factorial[n] * inverseFactorial[k] * inverseFactorial[n - k]
      print(answer.val)
    }
  }
}
