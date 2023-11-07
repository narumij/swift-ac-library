import Foundation

protocol DefaultInitialize {
    init()
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


struct mcf_graph<Cap: SignedInteger & FixedWidthInteger, Cost: SignedInteger & FixedWidthInteger> where Cap == Cost {
//  public:
    init() { }
    init(_ n: Int) { _n = n }

    mutating func add_edge(_ from: Int,_ to: Int,_ cap: Cap,_ cost: Cost) -> Int {
        assert(0 <= from && from < _n);
        assert(0 <= to && to < _n);
        assert(0 <= cap);
        assert(0 <= cost);
        let m = _edges.count;
        _edges.append(.init(from, to, cap, 0, cost));
        return m;
    }

    struct edge {
        internal init(_ from: Int,_ to: Int,_ cap: Cap,_ flow: Cap,_ cost: Cost) {
            self.from = from
            self.to = to
            self.cap = cap
            self.flow = flow
            self.cost = cost
        }
        var from, to: Int;
        var cap, flow: Cap;
        var cost: Cost;
    };

    func get_edge(_ i: Int) -> edge {
        let m = _edges.count;
        assert(0 <= i && i < m);
        return _edges[i];
    }
    func edges() -> [edge] { return _edges; }

    mutating func flow(_ s: Int,_ t: Int) -> (Cap,Cost) {
        return flow(s, t, Cap.max);
    }
    mutating func flow(_ s: Int,_ t: Int,_ flow_limit: Cap) -> (Cap,Cost) {
        return slope(s, t, flow_limit).last!;
    }
    mutating func slope(_ s: Int,_ t: Int) -> [(Cap,Cost)] {
        return slope(s, t, Cap.max);
    }
    mutating func slope(_ s: Int,_ t: Int,_ flow_limit: Cap) -> [(Cap,Cost)] {
        assert(0 <= s && s < _n);
        assert(0 <= t && t < _n);
        assert(s != t);

        var m = _edges.count;
        var edge_idx = [Int](repeating:0, count:m);

        var g = {
            var degree = [Int](repeating:0,count:_n), redge_idx = [Int](repeating: 0, count: m);
            var elist: [(Int,_edge)] = [];
            elist.reserveCapacity(2 * m);
//            for (int i = 0; i < m; i++) {
            for i in 0..<m {
                var e = _edges[i];
                edge_idx[i] = degree[e.from]; degree[e.from] += 1
                redge_idx[i] = degree[e.to]; degree[e.to] += 1
                elist.append((e.from, .init(e.to, -1, e.cap - e.flow, e.cost)));
                elist.append((e.to, .init(e.from, -1, e.flow, -e.cost)));
            }
            var _g = `internal`.csr<_edge>(_n, elist);
//            for (int i = 0; i < m; i++) {
            for i in 0..<m {
                var e = _edges[i];
                edge_idx[i] += _g.start[e.from];
                redge_idx[i] += _g.start[e.to];
                _g.elist[edge_idx[i]].rev = redge_idx[i];
                _g.elist[redge_idx[i]].rev = edge_idx[i];
            }
            return _g;
        }();

        var result = slope(g, s, t, flow_limit);

//        for (int i = 0; i < m; i++) {
        for i in 0..<m {
            var e = g.elist[edge_idx[i]];
            _edges[i].flow = _edges[i].cap - e.cap;
        }

        return result;
    }

//  private:
    var _n: Int;
    var _edges: [edge] = [];

    // inside edge
    struct _edge: DefaultInitialize {
        internal init() {
            to = 0
            rev = 0
            cap = 0
            cost = 0
        }
        internal init(_ to: Int,_ rev: Int,_ cap: Cap,_ cost: Cost) {
            self.to = to
            self.rev = rev
            self.cap = cap
            self.cost = cost
        }
        
        var to, rev: Int;
        var cap: Cap;
        var cost: Cost;
    };

    struct Q {
        internal init(_ key: Cost,_ to: Int) {
            self.key = key
            self.to = to
        }
        var key: Cost;
        var to: Int;
        static func <(lhs: Q, rhs: Q) -> Bool { return lhs.key > rhs.key; }
    };

    func slope(_ g: `internal`.csr<_edge>,
               _ s: Int,
               _ t: Int,
               _ flow_limit: Cap) -> [(Cap, Cost)] {
        var g = g
        // variants (C = maxcost):
        // -(n-1)C <= dual[s] <= dual[i] <= dual[t] = 0
        // reduced cost (= e.cost + dual[e.from] - dual[e.to]) >= 0 for all edge

        // dual_dist[i] = (dual[i], dist[i])
        var dual_dist = [(first: Cost,second: Cost)](repeating: (.init(),.init()), count: _n);
        var prev_e = [Int](repeating: 0, count:_n);
        var vis = [Bool](repeating: false, count: _n);
//        struct Q {
//            Cost key;
//            int to;
//            bool operator<(Q r) const { return key > r.key; }
//        };
        var que_min = [Int]();
        var que = [Q]();
        var dual_ref = {
//            for (int i = 0; i < _n; i++) {
            for i in 0..<_n {
                dual_dist[i].second = Cost.max;
            }
//            std::fill(vis.begin(), vis.end(), false);
            vis.withUnsafeMutableBufferPointer{ $0.update(repeating: false) }
            que_min.removeAll();
            que.removeAll();

            // que[0..heap_r) was heapified
            var heap_r = 0;

            dual_dist[s].second = 0;
            que_min.append(s);
            while (!que_min.isEmpty || !que.isEmpty) {
                var v: Int;
                if (!que_min.isEmpty) {
                    v = que_min.last!;
                    que_min.popLast();
                } else {
                    while (heap_r < que.count) {
                        heap_r += 1;
                        std::push_heap(que.begin(), que.begin() + heap_r);
                    }
                    v = que.front().to;
                    std::pop_heap(que.begin(), que.end());
                    que.pop_back();
                    heap_r--;
                }
                if (vis[v]) { continue; }
                vis[v] = true;
                if (v == t) { break; }
                // dist[v] = shortest(s, v) + dual[s] - dual[v]
                // dist[v] >= 0 (all reduced cost are positive)
                // dist[v] <= (n-1)C
                var dual_v = dual_dist[v].first, dist_v = dual_dist[v].second;
//                for (int i = g.start[v]; i < g.start[v + 1]; i++) {
                for i in g.start[v]..<g.start[v + 1] {
                    var e = g.elist[i];
                    if (!e.cap) { continue; }
                    // |-dual[e.to] + dual[v]| <= (n-1)C
                    // cost <= C - -(n-1)C + 0 = nC
                    var cost = e.cost - dual_dist[e.to].first + dual_v;
                    if (dual_dist[e.to].second - dist_v > cost) {
                        var dist_to = dist_v + cost;
                        dual_dist[e.to].second = dist_to;
                        prev_e[e.to] = e.rev;
                        if (dist_to == dist_v) {
                            que_min.append(e.to);
                        } else {
                            que.append(Q(dist_to, e.to));
                        }
                    }
                }
            }
            if (!vis[t]) {
                return false;
            }

//            for (int v = 0; v < _n; v++) {
            for v in 0..<_n {
                if (!vis[v]) { continue; }
                // dual[v] = dual[v] - dist[t] + dist[v]
                //         = dual[v] - (shortest(s, t) + dual[s] - dual[t]) +
                //         (shortest(s, v) + dual[s] - dual[v]) = - shortest(s,
                //         t) + dual[t] + shortest(s, v) = shortest(s, v) -
                //         shortest(s, t) >= 0 - (n-1)C
                dual_dist[v].first -= dual_dist[t].second - dual_dist[v].second;
            }
            return true;
        };
        var flow: Cap = 0;
        var cost: Cost = 0, prev_cost_per_flow: Cost = -1;
        var result: [(Cap,Cost)] = [(0, 0)];
        while (flow < flow_limit) {
            if (!dual_ref()) { break; }
            var c = flow_limit - flow;
//            for (int v = t; v != s; v = g.elist[prev_e[v]].to) {
            var v = t
            while v != s { v = g.elist[prev_e[v]].to;
                c = min(c, g.elist[g.elist[prev_e[v]].rev].cap);
            }
//            for (int v = t; v != s; v = g.elist[prev_e[v]].to) {
            while v != s { v = g.elist[prev_e[v]].to;
                var e = g.elist[prev_e[v]];
                e.cap += c;
                g.elist[e.rev].cap -= c;
            }
            var d = -dual_dist[s].first;
            flow += c;
            cost += c * d;
            if (prev_cost_per_flow == d) {
                result.removeLast();
            }
            result.append((flow, cost));
            prev_cost_per_flow = d;
        }
        return result;
    }
};
