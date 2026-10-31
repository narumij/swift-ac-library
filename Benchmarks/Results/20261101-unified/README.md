# Unified Swift / C++ ACL benchmarks

Product revision: `62e4bdd`. All thirteen workloads, three cycles, powers-of-two sizes, per-workload size caps. Swift Release -O, C++ -O3, no sanitizers.

Times are mean cycle minima in ns per input element, including construction and destruction. Swift/C++ below 1 means Swift took less time. See [methodology](../../README.md) and [workload details](../../Extended.md).

| Workload | N | Swift | C++ | Swift/C++ |
| --- | ---: | ---: | ---: | ---: |
| DSU merge and size | 2,097,152 | 27.8 | 29.6 | 0.94× |
| SegTree random updates | 2,097,152 | 115.6 | 85.0 | 1.36× |
| SegTree range sums | 2,097,152 | 118.3 | 108.1 | 1.09× |
| Fenwick add and prefix sum | 2,097,152 | 44.7 | 44.7 | 1.00× |
| LazySegTree range add and sum | 262,144 | 433.9 | 390.6 | 1.11× |
| SCC grouped cycles | 131,072 | 47.5 | 37.7 | 1.26× |
| TwoSAT planted clauses | 131,072 | 87.9 | 57.5 | 1.53× |
| MaxFlow sparse network | 32,768 | 544.0 | 379.7 | 1.43× |
| MinCostFlow sparse network | 1,024 | 8244.1 | 10999.2 | 0.75× |
| Convolution modulo 998244353 | 262,144 | 59.0 | 58.9 | 1.00× |
| Suffix array alphabet 26 | 262,144 | 53.4 | 41.7 | 1.28× |
| Z algorithm alphabet 26 | 262,144 | 3.7 | 3.5 | 1.06× |
| ModInt multiply and add | 2,097,152 | 4.3 | 4.4 | 1.00× |

All 90 verification cases passed (21 initial and 69 extended cases). This validates the selected workloads, not arbitrary inputs.

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
