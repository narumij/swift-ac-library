import Foundation

enum `internal` { }

extension `internal` {

    static func bit_ceil(_ n: UInt) -> UInt {
        var x: UInt = 1;
        while (x < UInt(n)) { x *= 2; }
        return x;
    }

    static func countr_zero(_ x: UInt) -> Int {
        if x == 0 { return 64 }
        var n: UInt = 1
        var x = x
        if x & 0xFFFFFFFF == 0 { n = n + 32; x = x >> 32 }
        if x & 0x0000FFFF == 0 { n = n + 16; x = x >> 16 }
        if x & 0x000000FF == 0 { n = n + 8;  x = x >> 8  }
        if x & 0x0000000F == 0 { n = n + 4;  x = x >> 4  }
        if x & 0x00000003 == 0 { n = n + 2;  x = x >> 2  }
        return Int(n - x & 1)
    }
}

extension `internal` {
    
    struct simple_queue<T> {
        var payload: [T];
        var pos = 0;
        mutating func reserve(_ n: Int) { payload.reserveCapacity(n); }
        func size() -> Int { return payload.count - pos; }
        func empty() -> Bool { return pos == payload.count; }
        mutating func push(_ t: T) { payload.append(t); }
        func front() -> T { return payload[pos]; }
        mutating func clear() {
            payload.removeAll();
            pos = 0;
        }
        mutating func pop() { pos += 1; }
    };
}

extension `internal` {
    
    struct csr<E: DefaultInitialize> {
        var start: [Int];
        var elist: [E];
        init(_ n: Int,_ edges: [(first: Int,second: E)]) {
            start = [Int](repeating:0, count:n + 1)
            elist = [E](repeating: .init(), count: edges.count)
//            for (auto e : edges) {
            for e in edges {
                start[e.first + 1] += 1;
            }
//            for (int i = 1; i <= n; i++) {
            for i in 1..<=n {
                start[i] += start[i - 1];
            }
            var counter = start;
//            for (auto e : edges) {
            for e in edges {
                elist[counter[e.first]] = e.second;
                counter[e.first] += 1
            }
        }
    };
}

