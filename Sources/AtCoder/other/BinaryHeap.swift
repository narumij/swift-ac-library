import Foundation

// swift-collections 1.1.0以降では不要

extension Array: BinaryHeap {
    @inlinable @inline(__always)
    mutating func __update_binary_heap<R>(_ comp: @escaping (Element, Element) -> Bool,
                             _ body: (BinaryHeapUnsafeHandle<Element>) -> R) -> R {
        body(BinaryHeapUnsafeHandle(&self, startIndex: startIndex, endIndex: endIndex, comp))
    }
}

protocol BinaryHeap: Sequence {
    @inlinable @inline(__always)
    mutating func __update_binary_heap<R>(_ comp: @escaping (Element, Element) -> Bool,
                                          _ body: (BinaryHeapUnsafeHandle<Element>) -> R) -> R
}

extension BinaryHeap {
    mutating func make_heap(_ end: Int,_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.make_heap(end) }
    }
    mutating func push_heap(_ end: Int,_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.push_heap(end) }
    }
    mutating func pop_heap(_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.pop_heap($0.endIndex) }
    }
}

extension Int {
    // https://en.wikipedia.org/wiki/Binary_heap
    @inlinable @inline(__always)
    var parent:     Int { (self - 1) >> 1 }
    @inlinable @inline(__always)
    var leftChild:  Int { (self << 1) + 1 }
    @inlinable @inline(__always)
    var rightChild: Int { (self << 1) + 2 }
}

@usableFromInline
struct BinaryHeapUnsafeHandle<Element> {
    @inlinable @inline(__always)
    internal init(_ buffer: UnsafeMutablePointer<Element>,
                  startIndex: Int, endIndex: Int,
                  _ comp: @escaping (Element, Element) -> Bool)
    {
        self.buffer = buffer
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.comp = comp
    }
    @usableFromInline
    let buffer: UnsafeMutablePointer<Element>
    @usableFromInline
    let comp: (Element, Element) -> Bool
    @usableFromInline
    let startIndex: Int
    @usableFromInline
    let endIndex: Int
}

extension BinaryHeapUnsafeHandle {
    @usableFromInline
    typealias Index = Int
    
    @inlinable @inline(__always)
    func push_heap(_ limit: Index) {
        heapifyUp(limit, limit - 1, comp)
    }
    @inlinable @inline(__always)
    func pop_heap(_ limit: Index) {
        guard limit > 0, startIndex != limit - 1 else { return }
        swap(&buffer[startIndex], &buffer[limit - 1])
        heapifyDown(limit - 1, startIndex, comp)
    }
    @inlinable @inline(__always)
    func heapifyUp(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        guard i >= startIndex else { return }
        let element = buffer[i]
        var current = i
        while current > startIndex {
            let parent = current.parent
            guard !comp(buffer[parent], element) else { break }
            (buffer[current], current) = (buffer[parent], parent)
        }
        buffer[current] = element
    }
    @inlinable @inline(__always)
    func heapifyDown(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        let element = buffer[i]
        var (current, selected) = (i,i)
        while current < limit {
            let leftChild = current.leftChild
            let rightChild = leftChild + 1
            if leftChild < limit,
               comp(buffer[leftChild], element)
            {
                selected = leftChild
            }
            if rightChild < limit,
               comp(buffer[rightChild], current == selected ? element : buffer[selected])
            {
                selected = rightChild
            }
            if selected == current { break }
            (buffer[current], current) = (buffer[selected], selected)
        }
        buffer[current] = element
    }
    private func heapify(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        guard let index = heapifyIndex(limit, i, comp) else { return }
        swap(&buffer[i],&buffer[index])
        heapify(limit, index, comp)
    }
    private func heapifyIndex(_ limit: Index,_ current: Index,_ comp: (Element, Element) -> Bool) -> Index? {
        var next = current
        if current.leftChild < limit,
           comp(buffer[current.leftChild], buffer[next])
        {
            next = current.leftChild
        }
        if current.rightChild < limit,
           comp(buffer[current.rightChild], buffer[next])
        {
            next = current.rightChild
        }
        return next == current ? nil : next
    }
    func isHeap(_ limit: Index) -> Bool {
        (startIndex..<limit).allSatisfy{ heapifyIndex(limit, $0, comp) == nil }
    }
    func make_heap(_ limit: Index) {
        for i in stride(from: limit / 2, through: startIndex, by: -1) {
            heapify(limit, i, comp)
        }
        assert(isHeap(limit))
    }
}
