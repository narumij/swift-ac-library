//
//  File.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import Foundation

// experimental
struct CPPRangeReversed<Bound> where Bound: Comparable & Numeric {
    let start: Bound
    let end: Bound
}

extension CPPRangeReversed: Sequence {
    typealias Element = Bound
    func makeIterator() -> Iterator { Iterator(start: start, end: end) }
    struct Iterator: IteratorProtocol {
        init(start current: Bound, end: Bound) {
            self.end = end; self.current = current
        }
        private let end: Bound
        private var current: Bound
        mutating func next() -> Bound? {
            guard current > end else { return nil }
            defer { current -= 1 }
            return current
        }
    }
}

infix operator ..>: RangeFormationPrecedence

func ..> <Bound: Comparable>(lhs: Bound, rhs: Bound) -> CPPRangeReversed<Bound> {
    CPPRangeReversed(start: lhs, end: rhs)
}
