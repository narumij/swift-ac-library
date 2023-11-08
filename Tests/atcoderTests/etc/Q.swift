//
//  File.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import Foundation

extension Int {
#if true
    // https://en.wikipedia.org/wiki/Binary_heap
    var parent:     Int { (self - 1) >> 1 }
    var leftChild:  Int { (self << 1) + 1 }
    var rightChild: Int { (self << 1) + 2 }
#elseif false
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
        heapifyUp(limit, limit - 1, condition)
    }
    func pop_heap(_ limit: Int,_ condition: (Element, Element) -> Bool) {
        guard limit > 0 else { return }
        swapAt(startIndex, limit - 1)
        heapifyDown(limit - 1, startIndex, condition)
    }
    private func heapifyUp(_ limit: Int,_ i: Int,_ condition: (Element, Element) -> Bool) {
        let element = self[i]
        var current = i
        while current > startIndex {
            let parent = current.parent
            guard !condition(self[parent], element) else { break }
            (self[current], current) = (self[parent], parent)
        }
        self[current] = element
    }
    private func heapifyDown(_ limit: Int,_ i: Int,_ condition: (Element, Element) -> Bool) {
        let element = self[i]
        var (current, selected) = (i,i)
        while current < limit {
            let leftChild = current.leftChild
            let rightChild = leftChild + 1
            if leftChild < limit,
               condition(self[leftChild], element)
            {
                selected = leftChild
            }
            if rightChild < limit,
               condition(self[rightChild], current == selected ? element : self[selected])
            {
                selected = rightChild
            }
            if selected == current { break }
            (self[current], current) = (self[selected], selected)
        }
        self[current] = element
    }
    private func heapify(_ limit: Int,_ i: Int,_ condition: (Element, Element) -> Bool) {
        guard let index = heapifyIndex(limit, i, condition) else { return }
        swapAt(i, index)
        heapify(limit, index, condition)
    }
    private func heapifyIndex(_ limit: Int,_ current: Int,_ condition: (Element, Element) -> Bool) -> Index? {
        var next = current
        if current.leftChild < limit,
           condition(self[current.leftChild], self[next])
        {
            next = current.leftChild
        }
        if current.rightChild < limit,
           condition(self[current.rightChild], self[next])
        {
            next = current.rightChild
        }
        return next == current ? nil : next
    }
    func isHeap(_ limit: Int,_ condition: (Element, Element) -> Bool) -> Bool {
        (startIndex..<limit).allSatisfy{ heapifyIndex(limit, $0, condition) == nil }
    }
    func make_heap(_ limit: Int,_ condition: (Element, Element) -> Bool) {
        for i in stride(from: limit / 2, through: startIndex, by: -1) {
            heapify(limit, i, condition)
        }
        assert(isHeap(limit, condition))
    }
}
