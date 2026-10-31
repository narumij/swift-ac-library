# Updated Swift / C++ ACL benchmarks

Measured the working tree based on `7464bc7`, including all previous optimizations, plus the uncommitted MaxFlow exhausted-vertex pruning and reusable BFS queue. See changes.diff for the exact source changes. All thirteen workloads were rerun; no historical timing data was reused.

Release -O / C++ -O3, no sanitizers, three cycles, powers-of-two sizes, maximum 2M subject to each workload cap. Times are mean cycle minima in ns per input element, including construction and destruction. See [methodology](../../README.md).

| Workload | N | Swift | C++ | Swift/C++ |
| --- | ---: | ---: | ---: | ---: |
| DSU merge and size | 2,097,152 | 27.8 | 30.7 | 0.91× |
| SegTree random updates | 2,097,152 | 130.0 | 89.2 | 1.46× |
| SegTree range sums | 2,097,152 | 112.3 | 113.7 | 0.99× |
| Fenwick add and prefix sum | 2,097,152 | 47.5 | 45.7 | 1.04× |
| LazySegTree range add and sum | 262,144 | 399.1 | 401.5 | 0.99× |
| SCC grouped cycles | 131,072 | 49.1 | 38.8 | 1.27× |
| TwoSAT planted clauses | 131,072 | 92.3 | 60.7 | 1.52× |
| MaxFlow sparse network | 32,768 | 486.2 | 380.5 | 1.28× |
| MinCostFlow sparse network | 1,024 | 8055.4 | 11094.0 | 0.73× |
| Convolution modulo 998244353 | 262,144 | 62.4 | 60.6 | 1.03× |
| Suffix array alphabet 26 | 262,144 | 44.0 | 42.6 | 1.04× |
| Z algorithm alphabet 26 | 262,144 | 3.8 | 3.5 | 1.09× |
| ModInt multiply and add | 2,097,152 | 4.4 | 4.5 | 0.96× |

All 90 verification cases passed. This validates these workloads, not all inputs.

## Charts

### DSU merge and size

![DSU merge and size](<charts/01 DSU merge and size.png>)

### SegTree random updates

![SegTree random updates](<charts/02 SegTree random updates.png>)

### SegTree range sums

![SegTree range sums](<charts/03 SegTree range sums.png>)

### Fenwick add and prefix sum

![Fenwick add and prefix sum](<charts/04 Fenwick add and prefix sum.png>)

### LazySegTree range add and sum

![LazySegTree range add and sum](<charts/05 LazySegTree range add and sum.png>)

### SCC grouped cycles

![SCC grouped cycles](<charts/06 SCC grouped cycles.png>)

### TwoSAT planted clauses

![TwoSAT planted clauses](<charts/07 TwoSAT planted clauses.png>)

### MaxFlow sparse network

![MaxFlow sparse network](<charts/08 MaxFlow sparse network.png>)

### MinCostFlow sparse network

![MinCostFlow sparse network](<charts/09 MinCostFlow sparse network.png>)

### Convolution modulo 998244353

![Convolution modulo 998244353](<charts/10 Convolution modulo 998244353.png>)

### Suffix array alphabet 26

![Suffix array alphabet 26](<charts/11 Suffix array alphabet 26.png>)

### Z algorithm alphabet 26

![Z algorithm alphabet 26](<charts/12 Z algorithm alphabet 26.png>)

### ModInt multiply and add

![ModInt multiply and add](<charts/13 ModInt multiply and add.png>)
