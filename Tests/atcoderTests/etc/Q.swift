//
//  File.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import Foundation

// 指定された範囲の配列をヒープ化する関数
func heapify<T: Comparable>(array: inout [T], from startIndex: Int, to endIndex: Int) {
    var currentIndex = startIndex
    var leftChildIndex = 2 * currentIndex + 1

    while leftChildIndex <= endIndex {
        let rightChildIndex = min(leftChildIndex + 1, endIndex)
        var largestChildIndex = leftChildIndex

        if rightChildIndex <= endIndex && array[rightChildIndex] > array[leftChildIndex] {
            largestChildIndex = rightChildIndex
        }

        if array[largestChildIndex] > array[currentIndex] {
            array.swapAt(currentIndex, largestChildIndex)
            currentIndex = largestChildIndex
            leftChildIndex = 2 * currentIndex + 1
        } else {
            break
        }
    }
}

// ヒープ化された配列を表示する関数
func printHeap<T>(_ array: [T]) {
    for (index, element) in array.enumerated() {
        print("Heap[\(index)]: \(element)")
    }
}

// テスト用の配列
var heapArray = [4, 10, 3, 5, 1, 2, 6]

// 特定の範囲をヒープ化（例：インデックス2から4までの範囲をヒープ化）
let startIndex = 2
let endIndex = 4

func hoge() {
    for i in (startIndex...endIndex).reversed() {
        heapify(array: &heapArray, from: i, to: endIndex)
    }
    
    // ヒープ化された配列を表示
    printHeap(heapArray)
}
