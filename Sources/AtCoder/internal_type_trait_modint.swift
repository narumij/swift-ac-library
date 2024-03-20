import Foundation

extension static_modint: HandleUnsigned { }
extension dynamic_modint: HandleUnsigned { }

extension modint_raw where Self: HandleUnsigned {
    public init(unsigned: CUnsignedInt) {
        self.init(raw: __modint_v(unsigned, umod: __modint_umod(Self.umod)))
    }
    public var unsigned: CUnsignedInt { val }
}
