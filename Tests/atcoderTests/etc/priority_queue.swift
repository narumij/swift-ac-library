import Foundation

struct priority_queue<Element> {
    internal init(storage: ContiguousArray<Element> = [], condition: @escaping (Element, Element) -> Bool) {
        self.storage = storage
        self.condition = condition
        self.storage.withUnsafeMutableBufferPointer { buffer in
            buffer.make_heap(buffer.count, condition)
        }
    }
    private var storage: ContiguousArray<Element> = []
    private let condition: (Element,Element) -> Bool
    mutating func push(_ element:Element) {
        storage.append(element)
        storage.withUnsafeMutableBufferPointer { buffer in
            buffer.push_heap(buffer.endIndex, condition)
        }
    }
    mutating func pop() -> Element? {
        guard !storage.isEmpty else { return nil }
        storage.withUnsafeMutableBufferPointer { buffer in
            buffer.pop_heap(buffer.endIndex, condition)
        }
        return storage.removeLast()
    }
    var isEmpty: Bool { storage.isEmpty }
    var first: Element? { storage.first }
}
