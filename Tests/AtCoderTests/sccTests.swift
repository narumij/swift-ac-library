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

  func testLongChainAndCycle() {
    let n = 100_000
    var graph = SCCGraph(n)
    for v in 0..<(n - 1) { graph.add_edge(v, v + 1) }
    XCTAssertEqual(graph.scc(), (0..<n).map { [$0] })
    graph.add_edge(n - 1, 0)
    XCTAssertEqual(graph.scc(), [Array(0..<n)])
  }

  func testBranchReturnOrder() {
    var graph = SCCGraph(6)
    // 子からの復帰、探索中の祖先への辺、確定済み成分への辺を含む。
    for (from, to) in [(0, 1), (1, 2), (2, 1), (0, 3), (3, 4), (4, 0), (3, 2)] {
      graph.add_edge(from, to)
    }
    XCTAssertEqual(graph.scc(), [[5], [0, 3, 4], [1, 2]])
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
