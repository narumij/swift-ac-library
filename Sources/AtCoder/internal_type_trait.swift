import Foundation

public protocol ToUnsignedType {
  associatedtype Unsigned where Unsigned: FixedWidthInteger & UnsignedInteger
  init(bitPattern: Unsigned)
  var unsigned: Unsigned { get }
}

extension UnsignedInteger {
  @inlinable
  @inline(__always)
  public init(bitPattern: Self) { self = bitPattern }
}

extension Int32: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: UInt32 { .init(bitPattern: self) }
}
extension Int64: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: UInt64 { .init(bitPattern: self) }
}
extension Int: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: UInt { .init(bitPattern: self) }
}

extension UInt32: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: Self { self }
}
extension UInt64: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: Self { self }
}
extension UInt: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: Self { self }
}

extension static_modint: ToUnsignedType {}
extension dynamic_modint: ToUnsignedType {}

// MARK: -

public enum numeric_limit<T: ___numeric_limit> {
  @inlinable @inline(__always)
  public static var max: T { T.__max }
}

public
protocol ___numeric_limit: Numeric
{
  static var __max: Self { get }
}
extension Int16: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension Int32: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension Int64: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension Int: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension UInt16: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension UInt32: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension UInt64: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension UInt: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .max }
}
extension Double: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .greatestFiniteMagnitude }
}
extension Float: ___numeric_limit {
  @inlinable @inline(__always) public static var __max: Self { .greatestFiniteMagnitude }
}
