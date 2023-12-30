import Foundation

public struct dsu {
    public typealias Element = Int
    // storageは参照型で、dsuは値型というより、C++のpimplパターンに近い形になっています。
    // このため、万が一コピーして変更を加えた場合、Swiftの常識に反した動作となります。
    var storage: _Storage<Element>
    public init() { storage = .init(n: 0) }
    public init(_ n: Int) { storage = .init(n: n) }
}

extension dsu {
    
    @usableFromInline
    struct _BufferHeader {
        @inlinable @inline(__always)
        internal init(capacity: Int, count: Int) {
            self.capacity = capacity
            self.count = count
        }
        public let capacity: Int
        public let count: Int
    }
    
    @usableFromInline
    class _Buffer: ManagedBuffer<_BufferHeader, Element> {
        deinit {
            let count = header.count
            withUnsafeMutablePointers {
                (pointerToHeader, pointerToElements) -> Void in
                pointerToElements.deinitialize(count: count)
                pointerToHeader.deinitialize(count: 1)
            }
        }
    }
    
    @usableFromInline
    struct _Storage<Element: SignedInteger> {
        
        @inlinable @inline(__always)
        init(_buffer: _BufferPointer) { self._buffer = _buffer }
        
        @inlinable @inline(__always)
        init(n: Int) {
            let count = n
            let object = _Buffer.create(minimumCapacity: count) {
                _BufferHeader(capacity: $0.capacity, count: count) }
            self.init(_buffer: _BufferPointer(unsafeBufferObject: object))
            _buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(repeating: -1, count: count)
            }
        }

        public typealias _BufferPointer = ManagedBufferPointer<_BufferHeader, Element>
        public var _buffer: _BufferPointer
        
        @inlinable @inline(__always)
        public var count: Int { _buffer.header.count }
        
        @inlinable @inline(__always)
        public mutating func __update<R>(_ body: (_UnsafeHandle<Element>) -> R) -> R {
            _buffer.withUnsafeMutablePointers{ _header, _elements in
                let handle = _UnsafeHandle(_header: _header, _elements: _elements)
                return body(handle)
            }
        }
    }
}

extension dsu {
    
    @usableFromInline
    struct _UnsafeHandle<Element: SignedInteger> {
        
        @inlinable @inline(__always)
        init(_header: UnsafeMutablePointer<_BufferHeader>,
             _elements: UnsafeMutablePointer<Element>) {
            self._header = _header
            self.parent_or_size = _elements
        }

        public var _header: UnsafeMutablePointer<_BufferHeader>
        public var parent_or_size: UnsafeMutablePointer<Element>
        public var _n: Int { _header.pointee.count }
    }
}

extension dsu._UnsafeHandle {
    
    typealias Stride = UnsafeMutablePointer<Element>.Stride
    
    func merge(_ a: Element,_ b: Element) -> Element {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        var x = leader(a), y = leader(b);
        if (x == y) { return x; }
        if (-parent_or_size[x] < -parent_or_size[y]) { swap(&x, &y); }
        (parent_or_size + Stride(x)).pointee += parent_or_size[y];
        (parent_or_size + Stride(y)).pointee = x;
        return x;
    }

    func same(_ a: Element,_ b: Element) -> Bool {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        return leader(a) == leader(b);
    }

    func leader(_ a: Element) -> Element {
        assert(0 <= a && a < _n);
        if (parent_or_size[a] < 0) { return a; }
        (parent_or_size + Stride(a)).pointee = leader(parent_or_size[a]);
        return parent_or_size[a]
    }

    func size(_ a: Element) -> Element {
        assert(0 <= a && a < _n);
        return -parent_or_size[leader(a)];
    }

    func groups() -> [[Element]] {
        var leader_buf = [Element](repeating: -1, count:_n), group_size = [Int](repeating: -1, count:_n)
        for i in 0..<_n {
            leader_buf[i] = leader(Element(i));
            group_size[leader_buf[i]] += 1;
        }
        var result: [[Element]] = [[Element]](repeating: [], count: _n);
        for i in 0..<_n {
            result[i].reserveCapacity(group_size[i])
        }
        for i in 0..<_n {
            result[leader_buf[i]].append(Element(i));
        }
        result.removeAll { $0.isEmpty }
        return result;
    }
}

public extension dsu {
    
    @discardableResult
    mutating func merge(_ a: Element,_ b: Element) -> Element {
        storage.__update { $0.merge(a, b) }
    }
    mutating func same(_ a: Element,_ b: Element) -> Bool {
        storage.__update { $0.same(a, b) }
    }
    mutating func leader(_ a: Element) -> Element {
        storage.__update { $0.leader(a) }
    }
    mutating func size(_ a: Element) -> Element {
        storage.__update { $0.size(a) }
    }
    mutating func groups() -> [[Element]] {
        storage.__update { $0.groups() }
    }
}

