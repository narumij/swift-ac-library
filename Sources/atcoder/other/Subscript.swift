import Foundation

public extension Array {
    subscript<I: FixedWidthInteger>(index: I) -> Element {
        get { self[Int(index)] }
        set { self[Int(index)] = newValue }
    }
}

public extension ContiguousArray {
    subscript<I: FixedWidthInteger>(index: I) -> Element {
        get { self[Int(index)] }
        set { self[Int(index)] = newValue }
    }
}
