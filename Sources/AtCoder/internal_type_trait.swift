import Foundation

public protocol HandleUnsigned {
    associatedtype Unsigned: FixedWidthInteger & UnsignedInteger
    init(unsigned: Unsigned)
    var unsigned: Unsigned { get }
}

extension SignedInteger {
    @inlinable @inline(__always)
    public var unsigned: Magnitude { magnitude }
}

extension UnsignedInteger {
    public init(unsigned: Self) { self = unsigned }
    @inlinable @inline(__always)
    public var unsigned: Self { self }
}

extension Int32: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}
extension Int64: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}
extension Int: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}

extension UInt32: HandleUnsigned { }
extension UInt64: HandleUnsigned { }
extension UInt: HandleUnsigned { }

