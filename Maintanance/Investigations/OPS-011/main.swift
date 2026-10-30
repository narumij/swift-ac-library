import Foundation
enum CustomMod: static_mod { static let umod: UInt = 998244353 }
let mode=CommandLine.arguments[1]
modint.set_mod(7)
DispatchQueue.concurrentPerform(iterations:4) { worker in
 for _ in 0..<(mode == "changing-mod" ? 10000 : 100) {
  switch mode {
  case "fixed-mod":precondition((modint(6)*modint(6)).val==1)
  case "changing-mod":if worker==0 {modint.set_mod(7)} else {precondition(modint.mod==7)}
  case "fft-builtin":precondition(convolution(mod_998_244_353.self,[Int](repeating:1,count:61),[Int](repeating:1,count:61))[60]==61)
  case "fft-custom":precondition(convolution(CustomMod.self,[Int](repeating:1,count:61),[Int](repeating:1,count:61))[60]==61)
  default:fatalError()
  }
 }
}
print("PASS",mode)
