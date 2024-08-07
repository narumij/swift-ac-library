import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

final class BinaryHeapTests: XCTestCase {

  let makeHeapResult10: [Int] = [9, 8, 6, 7, 4, 5, 2, 0, 3, 1]
  let pushHeapResult_0: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_1: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_2: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_3: [Int] = [1, 0, 2, 3, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_4: [Int] = [2, 0, 1, 3, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_5: [Int] = [3, 2, 1, 0, 4, 5, 6, 7, 8, 9]
  let pushHeapResult_6: [Int] = [4, 3, 1, 0, 2, 5, 6, 7, 8, 9]
  let pushHeapResult_7: [Int] = [5, 3, 4, 0, 2, 1, 6, 7, 8, 9]
  let pushHeapResult_8: [Int] = [6, 3, 5, 0, 2, 1, 4, 7, 8, 9]
  let pushHeapResult_9: [Int] = [7, 6, 5, 3, 2, 1, 4, 0, 8, 9]
  let pushHeapEachResult_1: [Int] = [9, 8, 6, 7, 4, 5, 2, 0, 3, 1, 1]
  let pushHeapEachResult_2: [Int] = [9, 8, 6, 7, 4, 5, 2, 0, 3, 1, 2]
  let pushHeapEachResult_3: [Int] = [9, 8, 6, 7, 4, 5, 2, 0, 3, 1, 3]
  let pushHeapEachResult_4: [Int] = [9, 8, 6, 7, 4, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_5: [Int] = [9, 8, 6, 7, 5, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_6: [Int] = [9, 8, 6, 7, 6, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_7: [Int] = [9, 8, 6, 7, 7, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_8: [Int] = [9, 8, 6, 7, 8, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_9: [Int] = [9, 9, 6, 7, 8, 5, 2, 0, 3, 1, 4]
  let pushHeapEachResult_10: [Int] = [10, 9, 6, 7, 8, 5, 2, 0, 3, 1, 4]
  let pushHeapResult10: [Int] = [9, 0, 2, 3, 1, 5, 6, 7, 8, 4]
  let popHeapResult_0: [Int] = [8, 7, 6, 3, 4, 5, 2, 0, 1]
  let popHeapResult_1: [Int] = [7, 4, 6, 3, 1, 5, 2, 0]
  let popHeapResult_2: [Int] = [6, 4, 5, 3, 1, 0, 2]
  let popHeapResult_3: [Int] = [5, 4, 2, 3, 1, 0]
  let popHeapResult_4: [Int] = [4, 3, 2, 0, 1]
  let popHeapResult_5: [Int] = [3, 1, 2, 0]
  let popHeapResult_6: [Int] = [2, 1, 0]
  let popHeapResult_7: [Int] = [1, 0]
  let popHeapResult_8: [Int] = [0]
  let popHeapResult_9: [Int] = []

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  #if DEBUG
    func testMake() throws {
      var actual: [Int] = (0..<10) + []
      actual.make_heap(actual.endIndex, >)
      XCTAssertEqual(makeHeapResult10, actual)
    }

    func testPush() throws {
      var actual: [Int] = (0..<10) + []
      let expects: [[Int]] = [
        pushHeapResult_0,
        pushHeapResult_1,
        pushHeapResult_2,
        pushHeapResult_3,
        pushHeapResult_4,
        pushHeapResult_5,
        pushHeapResult_6,
        pushHeapResult_7,
        pushHeapResult_8,
        pushHeapResult_9,
      ]
      for i in 0..<10 {
        for j in 0..<i {
          actual.push_heap(actual.startIndex + j, >)
        }
        XCTAssertEqual(expects[i], actual)
      }
    }

    func testPushEach() throws {
      let expects: [[Int]] = [
        pushHeapEachResult_1,
        pushHeapEachResult_2,
        pushHeapEachResult_3,
        pushHeapEachResult_4,
        pushHeapEachResult_5,
        pushHeapEachResult_6,
        pushHeapEachResult_7,
        pushHeapEachResult_8,
        pushHeapEachResult_9,
        pushHeapEachResult_10,
      ]
      for i in 1...10 {
        var actual: [Int] = (0..<10) + []
        actual.make_heap(actual.endIndex, >)
        actual.append(i)
        actual.push_heap(actual.endIndex, >)
        XCTAssertEqual(expects[i - 1], actual)
      }
    }

    func testPushAll() throws {
      // 使い方としては正しくない。stlとの挙動の近さを確認するだけのもの。
      var actual: [Int] = (0..<10) + []
      actual.push_heap(actual.endIndex, >)
      XCTAssertEqual(pushHeapResult10, actual)
    }

    func testPop() throws {
      let expects: [[Int]] = [
        popHeapResult_0,
        popHeapResult_1,
        popHeapResult_2,
        popHeapResult_3,
        popHeapResult_4,
        popHeapResult_5,
        popHeapResult_6,
        popHeapResult_7,
        popHeapResult_8,
        popHeapResult_9,
      ]
      var actual: [Int] = (0..<10) + []
      actual.make_heap(actual.endIndex, >)
      for i in 0..<10 {
        actual.pop_heap(>)
        _ = actual.removeLast()
        XCTAssertEqual(expects[i], actual)
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
  #endif

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}

/*

// fixture source code

#include<bits/stdc++.h>
using namespace std;

int main() {

    {
        vector<int> heap = {0,1,2,3,4,5,6,7,8,9};
        vector<int>::iterator iter;
        make_heap(heap.begin(), heap.end());
        cout <<"let makeHeapResult10: [Int] = [";
        for (iter=heap.begin(); iter!=heap.end(); iter++) {
            if (iter != heap.begin()) cout <<", ";
            cout << *iter;
        }
        cout << "]" << endl;
    }

    {
        for (int i = 0; i < 10; ++i) {
            vector<int> heap = {0,1,2,3,4,5,6,7,8,9};
            vector<int>::iterator iter;
            for (int j = 0; j < i; ++j) {
                push_heap(heap.begin(), heap.begin() + j);
            }
            cout <<"let pushHeapResult_" << i << ": [Int] = [";
            for (iter=heap.begin(); iter!=heap.end(); iter++) {
                if (iter != heap.begin()) cout <<", ";
                cout << *iter;
            }
            cout << "]" << endl;
        }
    }

    {
        for(int i = 1; i < 11; ++i) {
            vector<int> heap = {0,1,2,3,4,5,6,7,8,9};
            vector<int>::iterator iter;
            make_heap(heap.begin(), heap.end());
            heap.push_back(i);
            push_heap(heap.begin(), heap.end());
            cout <<"let pushHeapEachResult_" << i << ": [Int] = [";
            for (iter=heap.begin(); iter!=heap.end(); iter++) {
                if (iter != heap.begin()) cout <<", ";
                cout << *iter;
            }
            cout << "]" << endl;
        }
    }

    {
        vector<int> heap = {0,1,2,3,4,5,6,7,8,9};
        vector<int>::iterator iter;
        push_heap(heap.begin(), heap.end());
        cout <<"let pushHeapResult10: [Int] = [";
        for (iter=heap.begin(); iter!=heap.end(); iter++) {
            if (iter != heap.begin()) cout <<", ";
            cout << *iter;
        }
        cout << "]" << endl;
    }

    {
        vector<int> heap = {0,1,2,3,4,5,6,7,8,9};
        vector<int>::iterator iter;
        make_heap(heap.begin(), heap.end());

        for(int i = 0; i < 10; ++i) {
            pop_heap(heap.begin(), heap.end());
            heap.pop_back();
            cout <<"let popHeapResult_" << i << ": [Int] = [";
            for (iter=heap.begin(); iter!=heap.end(); iter++) {
                if (iter != heap.begin()) cout <<", ";
                cout << *iter;
            }
            cout << "]" << endl;
        }
    }
}

*/
