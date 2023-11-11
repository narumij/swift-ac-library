import Foundation

// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
struct fenwick_tree<T: FixedWidthInteger> {
//    using U = internal::to_unsigned_t<T>;
    typealias U = T.Magnitude

//  public:
    init() { _n = 0; data = [] }
    init(_ n: Int) { _n = n; data = [U](repeating: 0, count: n) }

    mutating func add(_ p: Int,_ x: T) {
        var p = p
        assert(0 <= p && p < _n);
        p += 1;
        while (p <= _n) {
            data[p - 1] += U(x);
            p += p & -p;
        }
    }

    func sum(_ l: Int,_ r: Int) -> T {
        assert(0 <= l && l <= r && r <= _n);
        return T(sum(r) - sum(l));
    }

//  private:
    var _n: Int;
    var data: [U];

    func sum(_ r: Int) -> U {
        var r = r
        var s: U = 0;
        while (r > 0) {
            s += data[r - 1];
            r -= r & -r;
        }
        return s;
    }
};

