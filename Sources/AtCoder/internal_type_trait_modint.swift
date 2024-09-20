import Foundation

extension static_modint: ToUnsignedType {}
extension dynamic_modint: ToUnsignedType {}

extension modint_raw where Self: ToUnsignedType {
  @inlinable
  public init(bitPattern i: CUnsignedInt) {
    self.init(raw: __modint_v(i, umod: __modint_umod(Self.umod)))
  }
  @inlinable
  public var unsigned: CUnsignedInt { .init(bitPattern: val) }
}
