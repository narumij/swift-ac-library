import Foundation

infix operator ..<=: RangeFormationPrecedence

public func ..<= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: 1)
}

infix operator ..>=: RangeFormationPrecedence

public func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: -1)
}
