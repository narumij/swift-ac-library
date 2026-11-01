import AtCoder
import CollectionsBenchmark
import CppACL

private func makeSwiftFlow(_ input: Input, reserved: Bool = false) -> MFGraph<Int> {
  let n = input.a.count
  var graph = MFGraph<Int>(count: n + 2)
  if reserved {
    // Include degree counting and reservation in construction timing.
    var counts = [Int](repeating: 0, count: n + 2)
    for i in 0..<n {
      counts[0] += 1; counts[i + 1] += 1
      counts[i + 1] += 1; counts[n + 1] += 1
      if i + 1 < n { counts[i + 1] += 1; counts[i + 2] += 1 }
    }
    graph.reserveCapacity(edgeCounts: counts)
  }
  for i in 0..<n {
    _ = graph.add_edge(0, i + 1, input.a[i] % 16 + 1)
    _ = graph.add_edge(i + 1, n + 1, input.b[i] % 16 + 1)
    if i + 1 < n { _ = graph.add_edge(i + 1, i + 2, 8) }
  }
  return graph
}

private func makeCppFlow(_ input: Input) -> UnsafeMutableRawPointer {
  input.a.withUnsafeBufferPointer { a in
    input.b.withUnsafeBufferPointer { b in
      acl_flow_create(a.count, a.baseAddress, b.baseAddress)!
    }
  }
}

func verifyFlowPhases() {
  for n in [1, 2, 17, 128, 1024, 32768] {
    let input = Input(n)
    var swift = makeSwiftFlow(input)
    let cpp = makeCppFlow(input)
    var reserved = makeSwiftFlow(input, reserved: true)
    let result = swift.flow(0, n + 1)
    precondition(result == reserved.flow(0, n + 1))
    precondition(result == acl_flow_run(cpp, n))
    precondition([result] == Extended.flow.swift(input))
    acl_flow_destroy(cpp)
    print("PASS flow phases n=\(n)")
  }
}

extension Benchmark {
  mutating func addFlowPhases() {
    addSimple(title: "Swift MaxFlow unreserved total", input: Input.self, maxSize: 32768) { input in
      var graph = makeSwiftFlow(input)
      blackHole(graph.flow(0, input.a.count + 1))
    }
    addSimple(title: "Swift MaxFlow reserved total", input: Input.self, maxSize: 32768) { input in
      var graph = makeSwiftFlow(input, reserved: true)
      blackHole(graph.flow(0, input.a.count + 1))
    }
    for phase in ["construction", "search", "destruction"] {
      add(title: "Swift MaxFlow reserved " + phase, input: Input.self, maxSize: 32768) { input in
        return { timer in
          var graph: MFGraph<Int>?
          if phase == "construction" {
            timer.measure { graph = makeSwiftFlow(input, reserved: true) }
            blackHole(graph!.get_edge(0).cap)
          } else {
            graph = makeSwiftFlow(input, reserved: true)
            if phase == "search" {
              timer.measure { blackHole(graph!.flow(0, input.a.count + 1)) }
            } else {
              timer.measure { graph = nil }
            }
          }
        }
      }
    }
    for phase in ["construction", "search", "destruction"] {
      add(title: "Swift MaxFlow phase " + phase, input: Input.self, maxSize: 32768) { input in
        return { timer in
          // Every sample owns a fresh graph. No CoW snapshot or residual-flow reuse.
          var graph: MFGraph<Int>?
          if phase == "construction" {
            timer.measure { graph = makeSwiftFlow(input) }
            blackHole(graph!.get_edge(0).cap)
          } else {
            graph = makeSwiftFlow(input)
            if phase == "search" {
              timer.measure { blackHole(graph!.flow(0, input.a.count + 1)) }
            } else {
              timer.measure { graph = nil }
            }
          }
        }
      }
      add(title: "C++ MaxFlow phase " + phase, input: Input.self, maxSize: 32768) { input in
        return { timer in
          var graph: UnsafeMutableRawPointer!
          if phase == "construction" {
            timer.measure { graph = makeCppFlow(input) }
            acl_flow_destroy(graph)
          } else {
            graph = makeCppFlow(input)
            if phase == "search" {
              timer.measure { blackHole(acl_flow_run(graph, input.a.count)) }
              acl_flow_destroy(graph)
            } else {
              timer.measure { acl_flow_destroy(graph) }
            }
          }
        }
      }
    }
  }
}
