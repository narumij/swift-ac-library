# Updated Swift / C++ ACL benchmarks

Measured the working tree based on `62e4bdd`, including unchecked integer arithmetic in LazySegTree, MaxFlow and MinCostFlow. See changes.diff for the exact source changes. All thirteen workloads were rerun; no historical timing data was reused.

Release -O / C++ -O3, no sanitizers, three cycles, powers-of-two sizes, maximum 2M subject to each workload cap. Times are mean cycle minima in ns per input element, including construction and destruction. See [methodology](../../README.md).

| Workload | N | Swift | C++ | Swift/C++ |
| --- | ---: | ---: | ---: | ---: |
| DSU merge and size | 2,097,152 | 27.8 | 32.7 | 0.85× |
| SegTree random updates | 2,097,152 | 120.1 | 89.4 | 1.34× |
| SegTree range sums | 2,097,152 | 114.1 | 112.0 | 1.02× |
| Fenwick add and prefix sum | 2,097,152 | 47.6 | 46.5 | 1.03× |
| LazySegTree range add and sum | 262,144 | 392.4 | 399.9 | 0.98× |
| SCC grouped cycles | 131,072 | 48.3 | 38.7 | 1.25× |
| TwoSAT planted clauses | 131,072 | 94.2 | 61.8 | 1.52× |
| MaxFlow sparse network | 32,768 | 525.2 | 372.5 | 1.41× |
| MinCostFlow sparse network | 1,024 | 7914.3 | 10944.1 | 0.72× |
| Convolution modulo 998244353 | 262,144 | 59.9 | 59.6 | 1.00× |
| Suffix array alphabet 26 | 262,144 | 53.7 | 41.6 | 1.29× |
| Z algorithm alphabet 26 | 262,144 | 4.0 | 3.5 | 1.16× |
| ModInt multiply and add | 2,097,152 | 4.4 | 4.4 | 0.99× |

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
