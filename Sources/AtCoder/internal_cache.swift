import Foundation

extension _Internal {

  @usableFromInline
  struct Cache<each T: Hashable, Output> {

    @usableFromInline
    var cache: [Pack: Output] = [:]

    @usableFromInline
    let source: (repeat each T) -> Output

    @inlinable
    @inline(__always)
    mutating func get(_ values: repeat each T) -> Output {
      let key = Pack(repeat each values)
      if let p = cache[key] { return p }
      let p = source(repeat each values)
      cache[key] = p
      return p
    }
  }
}

extension _Internal.Cache {

  public
    struct Pack
  {
    public
      typealias RawValue = (repeat each T)

    @usableFromInline
    var rawValue: RawValue

    @inlinable
    @inline(__always)
    public init(_ values: repeat each T) {
      self.rawValue = (repeat each values)
    }
  }
}

extension _Internal.Cache.Pack: Equatable where repeat each T: Equatable {

  @inlinable
  @inline(__always)
  static func == (lhs: Self, rhs: Self) -> Bool {
    for (l, r) in repeat (each lhs.rawValue, each rhs.rawValue) {
      if l != r {
        return false
      }
    }
    return true
  }
}

extension _Internal.Cache.Pack: Hashable where repeat each T: Hashable {

  @inlinable
  @inline(__always)
  func hash(into hasher: inout Hasher) {
    for l in repeat (each rawValue) {
      hasher.combine(l)
    }
  }
}
