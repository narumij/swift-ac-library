import Foundation
DispatchQueue.concurrentPerform(iterations: 4) { _ in
 for _ in 0..<100 {
  var d=DSU(100)
  for i in 1..<100 {_=d.merge(0,i)}
  precondition(d.size(0)==100)
 }
}
print("PASS DSU")
