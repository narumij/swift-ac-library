//
//  File.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import Foundation

extension Int {
#if true
    var parent: Int {
        ((self + 1) >> 1) - 1
    }
    var leftChild: Int {
        ((self + 1) << 1) - 1
    }
    var rightChild: Int {
        ((self + 1) << 1)
    }
#elseif false
    var parent: Int {
        (self + 1) / 2 - 1
    }
    var leftChild: Int {
        2 * (self + 1) - 1
    }
    var rightChild: Int {
        2 * (self + 1) + 1 - 1
    }
#else
    var parent: Int {
        self / 2
    }
    var leftChild: Int {
        2 * self
    }
    var rightChild: Int {
        2 * self + 1
    }
#endif
}

extension UnsafeMutableBufferPointer {
    func push_heap(_ limit: Int,_ condition: (Element, Element) -> Bool) {
        guard isHeap(limit - 1, condition) else {
            make_heap(limit, condition)
            return
        }
        heapifyUp(limit, limit - 1, condition)
        assert(isHeap(limit, condition))
    }
    func pop_heap(_ limit: Int,_ condition: (Element, Element) -> Bool) {
        swapAt(0, limit - 1)
        heapifyDown(limit, 0, condition)
    }
    func heapifyUp(_ limit: Int,_ i: Index,_ condition: (Element, Element) -> Bool) {
        var pos = i
        while pos > 0 {
            guard !condition(self[pos.parent], self[pos]) else { break }
            swapAt(pos, pos.parent)
            pos = pos.parent
        }
    }
    func heapifyDown(_ limit: Int,_ i: Index,_ condition: (Element, Element) -> Bool) {
        guard let index = heapipyIndex(limit, i, condition) else { return }
        swapAt(i, index)
        heapifyDown(limit, index, condition)
    }
    func heapipyIndex(_ limit: Int,_ current: Index,_ condition: (Element, Element) -> Bool) -> Index? {
        var next = current
        if current.leftChild < limit, condition(self[current.leftChild], self[next]) {
            next = current.leftChild
        }
        if current.rightChild < limit, condition(self[current.rightChild], self[next]) {
            next = current.rightChild
        }
        return next == current ? nil : next
    }
    func isHeap(_ limit: Int,_ condition: (Element, Element) -> Bool) -> Bool {
        (0..<limit).allSatisfy{ heapipyIndex(limit, $0, condition) == nil }
    }
    func make_heap(_ limit: Int,_ condition: (Element, Element) -> Bool) {
        for i in stride(from: limit / 2, through: 0, by: -1) {
            heapifyDown(limit, i, condition)
        }
        assert(isHeap(limit, condition))
    }
}
