# Current Swift / C++ ACL benchmarks

All thirteen charts were freshly measured from product revision `0166ab4`.
No historical timing samples were reused. MaxFlow includes both unreserved Swift
and explicit edge reservation; degree counting and reservation are included in timing.
C++ uses the original unreserved graph construction.

Apple M1, Swift 6.4 Release -O, C++ -O3 -DNDEBUG, no sanitizers.
Three cycles, powers-of-two sizes, maximum 2M with per-workload caps.
Values below are the mean of the cycle minima, in ns/input, including construction,
execution and destruction. See [methodology](../../README.md) and
[workload definitions](../../Extended.md). These specific inputs do not establish
general performance rankings. Bands are not confidence intervals.

All 96 verification cases passed before measurement (21 base, 69 extended,
6 maximum-flow reservation comparisons).

| Workload | N | Swift | C++ | Swift/C++ |
|---|---:|---:|---:|---:|
| DSU merge and size | 2,097,152 | 29.30 | 32.98 | 0.89 |
| SegTree random updates | 2,097,152 | 128.62 | 92.78 | 1.39 |
| SegTree range sums | 2,097,152 | 112.79 | 116.79 | 0.97 |
| Fenwick add and prefix sum | 2,097,152 | 48.23 | 46.83 | 1.03 |
| LazySegTree range add and sum | 262,144 | 387.23 | 387.16 | 1.00 |
| SCC grouped cycles | 131,072 | 47.17 | 37.65 | 1.25 |
| TwoSAT planted clauses | 131,072 | 79.86 | 58.42 | 1.37 |
| MaxFlow sparse network | 32,768 | 462.22 | 371.95 | 1.24 |
| MaxFlow (Swift reserved) | 32,768 | 357.65 | 371.95 | 0.96 |
| MinCostFlow sparse network | 1,024 | 7985.51 | 11057.85 | 0.72 |
| Convolution modulo 998244353 | 262,144 | 60.34 | 59.14 | 1.02 |
| Suffix array alphabet 26 | 262,144 | 42.79 | 42.33 | 1.01 |
| Z algorithm alphabet 26 | 262,144 | 3.60 | 3.51 | 1.02 |
| ModInt multiply and add | 2,097,152 | 4.39 | 4.48 | 0.98 |

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

