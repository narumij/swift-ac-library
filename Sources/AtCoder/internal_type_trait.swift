import Foundation

public protocol HandleUnsigned {
    associatedtype Unsigned: FixedWidthInteger & UnsignedInteger
    init(unsigned: Unsigned)
    var unsigned: Unsigned { get }
}

extension UnsignedInteger {
    public init(unsigned: Self) { self = unsigned }
}

extension Int32: HandleUnsigned {
    public init(unsigned: UInt32) { self.init(bitPattern: unsigned) }
    public var unsigned: UInt32 { .init(bitPattern: self) }
}
extension Int64: HandleUnsigned {
    public init(unsigned: UInt64) { self.init(bitPattern: unsigned) }
    public var unsigned: UInt64 { .init(bitPattern: self)  }
}
extension Int: HandleUnsigned {
    public init(unsigned: UInt) { self.init(bitPattern: unsigned) }
    public var unsigned: UInt { .init(bitPattern: self)  }
}

extension UInt32: HandleUnsigned { 
    public var unsigned: Self { self }
}
extension UInt64: HandleUnsigned {
    public var unsigned: Self { self }
}
extension UInt: HandleUnsigned { 
    public var unsigned: Self { self }
}
