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
  public var unsigned: UInt32 { _read { yield .init(bitPattern: self) } }
}
extension Int64: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: UInt64 { _read { yield .init(bitPattern: self) } }
}
extension Int: ToUnsignedType {
  @inlinable
  @inline(__always)
  public var unsigned: UInt { _read { yield .init(bitPattern: self) } }
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
  public static var max: T { _read { yield T.__max } }
}

public
  protocol ___numeric_limit: Numeric
{
  static var __max: Self { get }
}

extension FixedWidthInteger {
  @inlinable @inline(__always) public static var __max: Self { _read { yield .max } }
}

extension BinaryFloatingPoint {
  @inlinable @inline(__always) public static var __max: Self {
    _read { yield .greatestFiniteMagnitude }
  }
}

extension Int16: ___numeric_limit {}
extension Int32: ___numeric_limit {}
extension Int64: ___numeric_limit {}
extension Int: ___numeric_limit {}
extension UInt16: ___numeric_limit {}
extension UInt32: ___numeric_limit {}
extension UInt64: ___numeric_limit {}
extension UInt: ___numeric_limit {}
extension Double: ___numeric_limit {}
extension Float: ___numeric_limit {}

// MARK: -

public protocol NumericCastVisitor {
  associatedtype Cap
  associatedtype Cost
  func cast(_ value: Cap) -> Cost
}

public struct IntegerToIntegerVisitor<Cap: BinaryInteger, Cost: BinaryInteger>:
  NumericCastVisitor
{
  public func cast(_ value: Cap) -> Cost {
    return Cost(value)
  }
}

public struct IntegerToFloatVisitor<Cap: BinaryInteger, Cost: BinaryFloatingPoint>:
  NumericCastVisitor
{
  public func cast(_ value: Cap) -> Cost {
    return Cost(value)
  }
}

public struct FloatToIntegerVisitor<Cap: BinaryFloatingPoint, Cost: BinaryInteger>:
  NumericCastVisitor
{
  public func cast(_ value: Cap) -> Cost {
    return Cost(value)
  }
}

public struct FloatToFloatVisitor<Cap: BinaryFloatingPoint, Cost: BinaryFloatingPoint>:
  NumericCastVisitor
{
  public func cast(_ value: Cap) -> Cost {
    return Cost(value)
  }
}

public struct AnyNumericCastVisitor<Cap, Cost>: NumericCastVisitor {
  private let _cast: (Cap) -> Cost
  public init<V: NumericCastVisitor>(_ visitor: V) where V.Cap == Cap, V.Cost == Cost {
    self._cast = visitor.cast
  }
  public func cast(_ value: Cap) -> Cost {
    return _cast(value)
  }
}
