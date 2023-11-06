import Foundation

/// C++のループの挙動を、Swiftで楽に再現するためのもの。
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
/// この差異を吸収するために、演算子として以下を追加し、同じ挙動となるようにした。
/// ```
/// var r = 0
/// for n in 1..<=r { }
/// ```
struct CPPClosedRange<Bound> where Bound: Comparable & Numeric {
    let start: Bound
    let end: Bound
}

extension CPPClosedRange: Sequence {
    typealias Element = Bound
    func makeIterator() -> Iterator { Iterator(start: start, end: end) }
    struct Iterator: IteratorProtocol {
        init(start current: Bound, end: Bound) {
            self.end = end; self.current = current
        }
        private let end: Bound
        private var current: Bound
        mutating func next() -> Bound? {
            guard current <= end else { return nil }
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
    let start: Bound
    let end: Bound
}

extension CPPClosedRangeReversed: Sequence {
    typealias Element = Bound
    func makeIterator() -> Iterator { Iterator(start: start, end: end) }
    struct Iterator: IteratorProtocol {
        init(start current: Bound, end: Bound) {
            self.end = end; self.current = current
        }
        private let end: Bound
        private var current: Bound
        mutating func next() -> Bound? {
            guard current >= end else { return nil }
            defer { current -= 1 }
            return current
        }
    }
}

infix operator ..>=: RangeFormationPrecedence

func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> CPPClosedRangeReversed<Bound> {
    CPPClosedRangeReversed(start: lhs, end: rhs)
}
