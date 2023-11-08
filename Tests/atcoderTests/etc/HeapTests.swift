//
//  HeapTests.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import XCTest

extension Array where Element: Comparable {
    
    func isHeap(_ startIndex: Index,_ endIndex: Index, using comparator: (Element, Element) -> Bool = { $0 >= $1 }) -> Bool {
        for i in startIndex..<endIndex {
            let leftChildIndex = 2 * i + 1
            let rightChildIndex = 2 * i + 2
            if leftChildIndex < endIndex && !comparator(self[i], self[leftChildIndex]) {
                return false
            }
            if rightChildIndex < endIndex && !comparator(self[i], self[rightChildIndex]) {
                return false
            }
        }
        return true
    }
    
}

extension Array where Element: Comparable {
    
    mutating func pushHeap(_ element: Element, using comparator: (Element, Element) -> Bool = { $0 >= $1 }) {
        append(element)
        var currentIndex = count - 1
        
        while currentIndex > 0 {
            let parentIndex = (currentIndex - 1) / 2
            
            if comparator(self[currentIndex], self[parentIndex]) {
                swapAt(currentIndex, parentIndex)
                currentIndex = parentIndex
            } else {
                break
            }
        }
    }
}

extension Array where Element: Comparable {
    mutating func pushHeap(from start: Int, to end: Int, using comparator: (Element, Element) -> Bool = { $0 >= $1 }) {
        // 新しい要素を範囲の末尾に追加
        var currentIndex = (end - 1)
        var parentIndex = (currentIndex - 1) / 2
        // ヒープ条件を維持
        while currentIndex > start && !comparator(self[parentIndex], self[currentIndex]) {
            swapAt(currentIndex, parentIndex)
            currentIndex = parentIndex
            parentIndex = (currentIndex - 1) / 2
        }
    }
}

extension Array where Element: Comparable {
    
    @discardableResult
    mutating func pop_heap(using comparator: (Element, Element) -> Bool = { $0 >= $1 }) -> Element? {
        guard !isEmpty else { return nil }
        withUnsafeMutableBufferPointer { buffer in
            buffer.pop_heap(buffer.count, >)
        }
//        defer { assert(isHeap(startIndex, endIndex)) }
        return removeLast()
    }

    mutating func popHeap(using comparator: (Element, Element) -> Bool = { $0 >= $1 }) {
        guard !isEmpty else { return }

        // 最大の要素をルートから削除
        let lastIndex = count - 1
        swapAt(0, lastIndex)
        removeLast()

        // ヒープ条件を維持
        var currentIndex = 0
        var childIndex = 2 * currentIndex + 1

        while childIndex < count {
            let rightChild = childIndex + 1

            if rightChild < count && comparator(self[rightChild], self[childIndex]) {
                childIndex = rightChild
            }

            if comparator(self[childIndex], self[currentIndex]) {
                swapAt(childIndex, currentIndex)
                currentIndex = childIndex
                childIndex = 2 * currentIndex + 1
            } else {
                break
            }
        }
    }
}

extension Array where Element: Comparable {
#if false
    mutating func heapifyInRange(from start: Index, to end: Index, using comparator: (Element, Element) -> Bool) {
        var currentIndex = start
        var largestIndex = currentIndex
        while true {
            let leftChildIndex = 2 * currentIndex + 1
            let rightChildIndex = 2 * currentIndex + 2

            if leftChildIndex < end && comparator(self[leftChildIndex], self[largestIndex]) {
                largestIndex = leftChildIndex
            }

            if rightChildIndex < end && comparator(self[rightChildIndex], self[largestIndex]) {
                largestIndex = rightChildIndex
            }

            if largestIndex == currentIndex {
                break
            }

            self.swapAt(currentIndex, largestIndex)
            currentIndex = largestIndex
        }
    }
#else
    mutating func heapify(index: Int, endIndex: Int) {
        let leftChildIndex = 2 * index + 1
        let rightChildIndex = 2 * index + 2
        var largestIndex = index
        
        if leftChildIndex < endIndex && self[leftChildIndex] < self[largestIndex] {
            largestIndex = leftChildIndex
        }
        
        if rightChildIndex < endIndex && self[rightChildIndex] < self[largestIndex] {
            largestIndex = rightChildIndex
        }
        
        if largestIndex != index {
            swapAt(index, largestIndex)
            heapify(index: largestIndex, endIndex: endIndex)
        }
    }
#endif
}


extension Array where Element: Comparable {
    func isHeap(inRange range: Range<Int>, using comparator: (Element, Element) -> Bool = { $0 >= $1 }) -> Bool {
        let n = range.upperBound
        for i in range {
            let leftChildIndex = 2 * i + 1
            let rightChildIndex = 2 * i + 2
            
            if leftChildIndex < n && !comparator(self[i], self[leftChildIndex]) {
                return false
            }
            
            if rightChildIndex < n && !comparator(self[i], self[rightChildIndex]) {
                return false
            }
        }
        return true
    }
}

final class HeapTests: XCTestCase {
    
    let heaped = [20, 19, 15, 18, 11, 13, 14, 17, 9, 10, 2, 12, 6, 3, 7, 16, 8, 4, 1, 5]
    let poped = [19, 18, 15, 17, 11, 13, 14, 16, 9, 10, 2, 12, 6, 3, 7, 5, 8, 4, 1, 20]
    let poped2 = [18, 17, 15, 16, 11, 13, 14, 8, 9, 10, 2, 12, 6, 3, 7, 5, 1, 4, 19, 20]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
//        throw XCTSkip()
        
        XCTAssertTrue(heaped.isHeap(inRange: heaped.indices, using: >=))
        XCTAssertTrue(heaped.isHeap(heaped.startIndex, heaped.endIndex, using: >=))
        
        var b = (1...20).map{ $0 }
        b.withUnsafeMutableBufferPointer { buffer in
            buffer.make_heap(buffer.count, >)
        }
        XCTAssertEqual(heaped, b)
        b = b.sorted()
        b.withUnsafeMutableBufferPointer { buffer in
            for i in 1...20 {
                buffer.push_heap(i, >)
            }
        }
//        XCTAssertEqual(heaped, b)
        XCTAssertTrue(b.isHeap(b.startIndex, b.endIndex))
        b.withUnsafeMutableBufferPointer { buffer in
            XCTAssertTrue(buffer.isHeap(buffer.count, >))
        }

        var a = heaped
        XCTAssertEqual(20, a.pop_heap())
        XCTAssertEqual(poped.dropLast(), a)
        XCTAssertTrue(a.isHeap(a.startIndex, a.endIndex))
        a.withUnsafeMutableBufferPointer { buffer in
            XCTAssertTrue(buffer.isHeap(buffer.count, >))
        }
        XCTAssertEqual(19, a.pop_heap())
        XCTAssertEqual(poped2.dropLast().dropLast(), a)
        XCTAssertTrue(a.isHeap(a.startIndex, a.endIndex))
        a.withUnsafeMutableBufferPointer { buffer in
            XCTAssertTrue(buffer.isHeap(buffer.count, >))
        }
        for i in stride(from: 18, through: 1, by: -1) {
            XCTAssertEqual(i, a.pop_heap())
        }

        let heapArray: [Int] = [16, 14, 15, 10, 11, 13, 12, 5, 8, 9, 4, 6, 2, 7, 3, 1, 20, 18, 19, 17]

        XCTAssertFalse(heapArray.isHeap(inRange: heaped.indices, using: >=))
        XCTAssertFalse(heapArray.isHeap(heaped.startIndex, heaped.endIndex, using: >=))
        
        var c = [2]
        c.append(1)
        c.withUnsafeMutableBufferPointer { buffer in
            buffer.push_heap(buffer.count, >)
        }
        
        var d = [1]
        d.append(2)
        d.withUnsafeMutableBufferPointer { buffer in
            buffer.push_heap(buffer.count, >)
        }
    }
    
    func testIndex() throws {
        XCTAssertEqual(1, 0.leftChild)
        XCTAssertEqual(2, 0.rightChild)
        XCTAssertEqual(0, 1.parent)
        XCTAssertEqual(3, 1.leftChild)
        XCTAssertEqual(4, 1.rightChild)
        XCTAssertEqual(0, 2.parent)
        XCTAssertEqual(5, 2.leftChild)
        XCTAssertEqual(6, 2.rightChild)
        XCTAssertEqual(1, 3.parent)
        XCTAssertEqual(7, 3.leftChild)
        XCTAssertEqual(8, 3.rightChild)
        XCTAssertEqual(1, 4.parent)
        XCTAssertEqual(9, 4.leftChild)
        XCTAssertEqual(10, 4.rightChild)
        XCTAssertEqual(2, 5.parent)
        XCTAssertEqual(11, 5.leftChild)
        XCTAssertEqual(12, 5.rightChild)
        XCTAssertEqual(2, 6.parent)
        XCTAssertEqual(13, 6.leftChild)
        XCTAssertEqual(14, 6.rightChild)
    }

    func testPerformanceExample() throws {
        // throw XCTSkip()
        var pq = priority_queue<Int>(condition: >)
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            (0..<200000).forEach{ pq.push($0) }
            while let p = pq.pop() { }
        }
    }

//    func testPerformanceExample2() throws {
//        // throw XCTSkip()
//        var pq = priority_queue<Int>(condition: >)
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//            (0..<200000).forEach{ pq.push($0) }
//        }
//    }

}
