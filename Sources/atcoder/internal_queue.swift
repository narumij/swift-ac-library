import Foundation


extension _internal {
    // 使っていない。代わりにDequeを使っている。
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



