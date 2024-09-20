import Foundation

public protocol ToUnsignedType {
  associatedtype Unsigned where Unsigned: FixedWidthInteger & UnsignedInteger
  init(bitPattern: Unsigned)
  var unsigned: Unsigned { get }
}

extension UnsignedInteger {
  @inlinable
  public init(bitPattern: Self) { self = bitPattern }
}

extension Int32: ToUnsignedType {
  @inlinable
  public var unsigned: UInt32 { .init(bitPattern: self) }
}
extension Int64: ToUnsignedType {
  @inlinable
  public var unsigned: UInt64 { .init(bitPattern: self) }
}
extension Int: ToUnsignedType {
  @inlinable
  public var unsigned: UInt { .init(bitPattern: self) }
}

extension UInt32: ToUnsignedType {
  @inlinable
  public var unsigned: Self { self }
}
extension UInt64: ToUnsignedType {
  @inlinable
  public var unsigned: Self { self }
}
extension UInt: ToUnsignedType {
  @inlinable
  public var unsigned: Self { self }
}
