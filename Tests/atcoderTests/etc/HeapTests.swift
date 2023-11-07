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
        
        throw XCTSkip()
        
        XCTAssertTrue(heaped.isHeap(inRange: heaped.indices, using: >=))
        XCTAssertTrue(heaped.isHeap(heaped.startIndex, heaped.endIndex, using: >=))
        
        var b = (1...20).map{ $0 }
        for i in 0...20 {
            b.pushHeap(from: 0, to: i, using: >=)
        }
//        b.heapify(index: 0, endIndex: 20)
        XCTAssertEqual(heaped, b)

        var a = heaped
        a.popHeap()
        XCTAssertEqual(poped.dropLast(), a)
        a.popHeap()
        XCTAssertEqual(poped2.dropLast().dropLast(), a)

        var heapArray: [Int] = [16, 14, 15, 10, 11, 13, 12, 5, 8, 9, 4, 6, 2, 7, 3, 1, 20, 18, 19, 17]

        XCTAssertFalse(heapArray.isHeap(inRange: heaped.indices, using: >=))
        XCTAssertFalse(heapArray.isHeap(heaped.startIndex, heaped.endIndex, using: >=))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
