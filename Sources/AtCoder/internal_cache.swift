import Foundation

extension _Internal {

  @usableFromInline
  struct Cache<each T: Hashable, Output> {
    
    @usableFromInline
    var cache: [Key: Output] = [:]
    
    @usableFromInline
    let source: (repeat each T) -> Output
    
    @inlinable
    @inline(__always)
    mutating func get(_ values: repeat each T) -> Output {
      let key = Key(repeat each values)
      if let p = cache[key] { return p }
      let p = source(repeat each values)
      cache[key] = p
      return p
    }
  }
}

extension _Internal.Cache {
  
  public
  struct Key {
    
    public
      typealias Tuple = (repeat each T)

    @usableFromInline
    var tuple: Tuple
    
    @inlinable
    @inline(__always)
    public init(_ values: repeat each T) {
      self.tuple = (repeat each values)
    }
  }
}

extension _Internal.Cache.Key: Equatable where repeat each T: Equatable {
  
  @inlinable
  @inline(__always)
  static func == (lhs: Self, rhs: Self) -> Bool {
    for (l, r) in repeat (each lhs.tuple, each rhs.tuple) {
      if l != r {
        return false
      }
    }
    return true
  }
}

extension _Internal.Cache.Key: Hashable where repeat each T: Hashable {
  
  @inlinable
  @inline(__always)
  func hash(into hasher: inout Hasher) {
    for l in repeat (each tuple) {
      hasher.combine(l)
    }
  }
}
