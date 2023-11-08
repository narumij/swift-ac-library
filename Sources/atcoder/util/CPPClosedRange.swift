import Foundation

// C++のループの挙動を、Swiftで楽に再現するためのもの。
//
// 例えば、C++で以下の場合を、
// ```
// int r = 0;
// for (int n = 1; n <= r; n++) { }
// ```
// Swiftで
// ```
// var r = 0
// for n in 1...r { }
// ```
// とした場合、fatalErrorとなる。
// これを、
// ```
// var r = 0
// for n in 1...max(1,r) { }
// ```
// とした場合、C++は0回実行だが、Swiftでは1回実行してしまう。
//
// この差異を吸収するために、演算子として以下を追加し、同じ挙動となるようにした。
// ```
// var r = 0
// for n in 1..<=r { }
// ```
//
// 以下も追加してある。
// ```
// var r = 0
// for n in r..>=1 { }
// ```

infix operator ..<=: RangeFormationPrecedence

public func ..<= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: 1)
}

infix operator ..>=: RangeFormationPrecedence

public func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: -1)
}

