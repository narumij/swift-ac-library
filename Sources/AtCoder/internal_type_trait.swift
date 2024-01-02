import Foundation

public protocol HandleUnsigned {
    associatedtype Unsigned: FixedWidthInteger & UnsignedInteger
    init(unsigned: Unsigned)
    var unsigned: Unsigned { get }
}

//extension SignedInteger {
//    @inlinable @inline(__always)
//    public var unsigned: Magnitude { magnitude }
//}

extension UnsignedInteger {
    public init(unsigned: Self) { self = unsigned }
//    @inlinable @inline(__always)
}

extension Int32: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
    public var unsigned: Magnitude { .init(bitPattern: self) }
}
extension Int64: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
    public var unsigned: Magnitude { .init(bitPattern: self)  }
}
extension Int: HandleUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
    public var unsigned: Magnitude { .init(bitPattern: self)  }
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

