// verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod_1000000007
import AtCoder
import VerificationIO

enum Prime1: static_mod {
  static let umod: UInt = 167_772_161
  static let isPrime = true
}
enum Prime2: static_mod {
  static let umod: UInt = 469_762_049
  static let isPrime = true
}

@main
struct Solution {
  static func main() {
    var input = Input()
    let n = input.int(), m = input.int()
    let a = (0..<n).map { _ in input.int() }
    let b = (0..<m).map { _ in input.int() }
    let base = 1 << 15
    let al = a.map { $0 % base }, ah = a.map { $0 / base }
    let bl = b.map { $0 % base }, bh = b.map { $0 / base }
    // Every split coefficient sum is below 2^51, hence fits Int64.
    // Two coprime NTT primes also uniquely recover each low-part coefficient.
    let low1 = convolution(Prime1.self, al, bl)
    let low2 = convolution(Prime2.self, al, bl)
    let high = convolution_ll(ah, bh)
    let combined = convolution_ll(zip(al, ah).map(+), zip(bl, bh).map(+))
    let modulus = 1_000_000_007
    let baseSquared = base * base % modulus
    for i in 0..<(n + m - 1) {
      let low = crt([low1[i], low2[i]], [Int(Prime1.umod), Int(Prime2.umod)]).rem
      let cross = combined[i] - low - high[i]
      let answer = (low % modulus + (cross % modulus) * base + (high[i] % modulus) * baseSquared) % modulus
      fastPrint(answer, terminator: i == n + m - 2 ? 10 : 32)
    }
  }
}
