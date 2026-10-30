import Foundation
struct Sum: SegTreeOperator { static var e: Int { 0 }; static func op(_ a:Int,_ b:Int)->Int { a+b } }
DispatchQueue.concurrentPerform(iterations:4) { _ in
 for _ in 0..<100 {
  var f=FenwickTree<Int>(100);for i in 0..<100 {f.add(i,1)};precondition(f.sum(0,100)==100)
  var s=SegTree<Sum>([Int](repeating:1,count:100));s.set(0,2);precondition(s.all_prod()==101)
 }
}
print("PASS independent Fenwick/SegTree")
