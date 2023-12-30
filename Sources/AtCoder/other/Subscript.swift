import Foundation

public extension Array {
    subscript<I: BinaryInteger>(index: I) -> Element {
        get { self[Int(index)] }
        set { self[Int(index)] = newValue }
    }
}

public extension UnsafeMutablePointer {
    subscript<I: BinaryInteger>(index: I) -> Pointee {
        get { self[Int(index)] }
        set { self[Int(index)] = newValue }
    }
}
