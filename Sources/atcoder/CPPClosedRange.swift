import Foundation

/// C++のループの挙動を、Swiftで楽に再現するためのレンジ
///
/// 例えば、C++で以下の場合を、
/// ```
/// int r = 0;
/// for (int n = 1; n <= r; n++) { }
/// ```
/// Swiftで
/// ```
/// var r = 0
/// for n in 1...r { }
/// ```
/// とした場合、fatalErrorとなる。
/// これを、
/// ```
/// var r = 0
/// for n in 1...max(1,r) { }
/// ```
/// とした場合、C++は0回実行だが、Swiftでは1回実行してしまう。
///
/// この際を吸収するために、演算子として以下を追加し、同じ挙動となるようにした。
/// ```
/// var r = 0
/// for n in 1..<=r { }
/// ```
struct CPPClosedRange<Bound> where Bound: Comparable & Numeric {
    var start: Bound
    var end: Bound
}

extension CPPClosedRange: Sequence {
    typealias Element = Bound
    func makeIterator() -> Iterator {
        return Iterator(start: start, end: end, current: start)
    }
    struct Iterator: IteratorProtocol {
        var start: Bound
        var end: Bound
        var current: Bound
        mutating func next() -> Bound? {
            guard start <= end, current <= end else { return nil }
            defer { current += 1 }
            return current
        }
    }
}

infix operator ..<=: RangeFormationPrecedence

func ..<= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> CPPClosedRange<Bound> {
    CPPClosedRange(start: lhs, end: rhs)
}

struct CPPClosedRangeReversed<Bound> where Bound: Comparable & Numeric {
    var start: Bound
    var end: Bound
}

extension CPPClosedRangeReversed: Sequence {
    typealias Element = Bound
    func makeIterator() -> Iterator {
        return Iterator(start: start, end: end, current: start)
    }
    struct Iterator: IteratorProtocol {
        var start: Bound
        var end: Bound
        var current: Bound
        mutating func next() -> Bound? {
            guard start >= end, current >= end else { return nil }
            defer { current -= 1 }
            return current
        }
    }
}

infix operator ..>=: RangeFormationPrecedence

func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> CPPClosedRangeReversed<Bound> {
    CPPClosedRangeReversed(start: lhs, end: rhs)
}
