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
    public init(unsigned: CUnsignedInt) { self.init(raw: Self._v(uint: unsigned)) }
    public var unsigned: CInt.Magnitude { val() }
    public var description: String { val().description }
}
