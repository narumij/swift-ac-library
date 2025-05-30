import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

final class sccTests: XCTestCase {

  typealias scc_graph = SCCGraph

  func testEmpty() throws {
    let graph0: scc_graph = .init()
    XCTAssertEqual([], graph0.scc())
    let graph1: scc_graph = .init(0)
    XCTAssertEqual([], graph1.scc())
  }

  #if false
    func testAssign() throws {
      throw XCTSkip("代入のオーバーロードはSwiftにはない。")
    }
  #endif

  func testSimple() throws {
    var graph: scc_graph = .init(2)
    graph.add_edge(0, 1)
    graph.add_edge(1, 0)
    let scc = graph.scc()
    XCTAssertEqual(1, scc.count)
  }

  func testSelfLoop() throws {
    var graph: scc_graph = .init(2)
    graph.add_edge(0, 0)
    graph.add_edge(0, 0)
    graph.add_edge(1, 1)
    let scc = graph.scc()
    XCTAssertEqual(2, scc.count)
  }
  
  func testPractice2() throws {
    var graph: scc_graph = .init(6)
    graph.add_edge(1, 4)
    graph.add_edge(5, 2)
    graph.add_edge(3, 0)
    graph.add_edge(5, 5)
    graph.add_edge(4, 1)
    graph.add_edge(0, 3)
    graph.add_edge(4, 2)
    let scc = graph.scc()
    XCTAssertEqual(4, scc.count)
    XCTAssertEqual([[5], [1, 4], [2], [0, 3]], scc)
  }

  #if false
    func testInvalid() throws {
      throw XCTSkip("Swift Packageでは実施不可")
      var graph: scc_graph = .init(2)
      XCTAssertThrowsError(graph.add_edge(0, 10), ".*")
    }
  #endif
  
  func testPractice2Performanc() throws {
    self.measure {
      try! testPractice2()
    }
  }
}
