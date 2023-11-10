//
//  File.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import Foundation

infix operator ..>: RangeFormationPrecedence

func ..> <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideTo<Bound> {
    stride(from: lhs, to: rhs, by: -1)
}
