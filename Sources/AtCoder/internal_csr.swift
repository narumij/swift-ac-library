import Foundation

#if true
extension _Internal {

  public struct csr<E> {

    @usableFromInline
    var start: [Int]

    @usableFromInline
    var elist: [E]

    @inlinable
    @inline(__always)
    init(_ n: Int, _ edges: [(first: Int, second: E)]) {
      var start = [Int](repeating: 0, count: n + 1)
      for e in edges {
        start[e.first + 1] += 1
      }
      for i in stride(from: 1, through: n, by: 1) {
        start[i] += start[i - 1]
      }
      let elist = [E](unsafeUninitializedCapacity: edges.count) { elist, elistCount in
        var counter = start
        for e in edges {
          elist[counter[e.first]] = e.second
          counter[e.first] += 1
        }
        elistCount = edges.count
      }
      self.start = start
      self.elist = elist
    }
  }
}
#else
extension _Internal {

  public struct csr<E> {
    
    @usableFromInline
    let _start: Buffer<Int>
    @usableFromInline
    let _elist: Buffer<E>

    @usableFromInline
    var start: UnsafeMutablePointer<Int> { _start.pointer }

    @usableFromInline
    var elist: UnsafeMutablePointer<E> { _elist.pointer }

    @inlinable
    @inline(__always)
    init(_ n: Int, _ edges: [(first: Int, second: E)]) {
      _start = Buffer<Int>.create(withCapacity: n + 1)
      _elist = Buffer<E>.create(withCapacity: edges.count)
      start.initialize(repeating: 0, count: n)
      for e in edges {
        start[e.first + 1] += 1
      }
      for i in stride(from: 1, through: n, by: 1) {
        start[i] += start[i - 1]
      }
      withUnsafeTemporaryAllocation(of: Int.self, capacity: n + 1) { counter in
        counter.baseAddress?.initialize(from: start, count: n + 1)
        for e in edges {
          elist[counter[e.first]] = e.second
          counter[e.first] += 1
        }
      }
    }
  }
}

extension _Internal.csr {
  
  @usableFromInline
  struct Header {
    @inlinable
    @inline(__always)
    internal init(capacity: Int) {
      self.capacity = capacity
    }
    @usableFromInline var capacity: Int
  }

  @usableFromInline
  class Buffer<Element>: ManagedBuffer<Header, Element> {
    
    @inlinable
    deinit {
      self.withUnsafeMutablePointers { header, elements in
        elements.deinitialize(count: header.pointee.capacity)
        header.deinitialize(count: 1)
      }
    }
    @inlinable
    @inline(__always)
    var pointer: UnsafeMutablePointer<Element> {
      withUnsafeMutablePointerToElements({ $0 })
    }
    
    @inlinable
    public subscript(index: Int) -> Element {
      _read { yield pointer[index] }
      _modify { yield &pointer[index] }
    }
    
    @inlinable
    @inline(__always)
    internal static func create(
      withCapacity capacity: Int
    ) -> Buffer<Element> {
      let storage = Buffer<Element>.create(minimumCapacity: capacity) { _ in
        Header(capacity: capacity)
      }
      return unsafeDowncast(storage, to: Buffer<Element>.self)
    }
  }
}
#endif
