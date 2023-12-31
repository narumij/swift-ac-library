//
//  File.swift
//  
//
//  Created by narumij on 2023/12/17.
//

import Foundation

extension static_modint: ToUnsigned { }
extension dynamic_modint: ToUnsigned { }

extension internal_modint where Self: ToUnsigned {
    public init(unsigned: CUnsignedInt) {
        self.init(raw: __modint_v(unsigned, umod: __modint_umod(Self.umod())))
    }
    public var unsigned: CInt.Magnitude { val() }
}
