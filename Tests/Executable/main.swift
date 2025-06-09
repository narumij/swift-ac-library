import AtCoder

#if true
typealias mint = modint998244353
// std::mt19937 mt;
let n = 524288
let m = 524288
#if false
let mt = { mint(CInt.random(in: 0...CInt.max)) }
var a = [mint](repeating: 0, count: n)
var b = [mint](repeating: 0, count: m)

for i in 0..<n {
  a[i] = mt()
}
for i in 0..<m {
  b[i] = mt()
}
#else
let a = (0..<n).map{ mint($0) }
let b = (0..<m).map{ mint($0) }
#endif

let c = convolution(a, b)

print(c)
#endif
