import Foundation

public protocol ToUnsigned {
    associatedtype Unsigned: FixedWidthInteger & UnsignedInteger
    init(unsigned: Unsigned)
    var unsigned: Unsigned { get }
}

extension SignedInteger {
    public var unsigned: Magnitude { magnitude }
}

extension UnsignedInteger {
    public init(unsigned: Self) { self = unsigned }
    public var unsigned: Self { self }
}

extension Int32: ToUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}
extension Int64: ToUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}
extension Int: ToUnsigned {
    public init(unsigned: Magnitude) { self.init(bitPattern: unsigned) }
}

extension UInt32: ToUnsigned { }
extension UInt64: ToUnsigned { }
extension UInt: ToUnsigned { }

