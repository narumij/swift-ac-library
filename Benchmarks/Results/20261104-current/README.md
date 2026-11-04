# Current Swift / C++ ACL benchmarks

All thirteen charts were freshly measured from product revision `9d8e73eae4b4f671a27a53413f2a2ee4d399703e` on 2026-11-04.
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
The reserved MaxFlow benchmark still calls the deprecated `reserveCapacity(edgeCounts:)` API.
It is retained here to preserve the existing workload; the build completed successfully.

| Workload | N | Swift | C++ | Swift/C++ |
|---|---:|---:|---:|---:|
| DSU merge and size | 2,097,152 | 30.49 | 35.03 | 0.87 |
| SegTree random updates | 2,097,152 | 119.10 | 91.82 | 1.30 |
| SegTree range sums | 2,097,152 | 116.29 | 113.22 | 1.03 |
| Fenwick add and prefix sum | 2,097,152 | 50.45 | 47.73 | 1.06 |
| LazySegTree range add and sum | 262,144 | 400.86 | 404.11 | 0.99 |
| SCC grouped cycles | 131,072 | 42.48 | 37.89 | 1.12 |
| TwoSAT planted clauses | 131,072 | 73.48 | 58.76 | 1.25 |
| MaxFlow unreserved total | 32,768 | 369.28 | 373.11 | 0.99 |
| MaxFlow reserved total | 32,768 | 304.14 | 373.11 | 0.82 |
| MinCostFlow sparse network | 1,024 | 8123.03 | 10864.41 | 0.75 |
| Convolution modulo 998244353 | 262,144 | 62.69 | 73.76 | 0.85 |
| Suffix array alphabet 26 | 262,144 | 45.72 | 42.21 | 1.08 |
| Z algorithm alphabet 26 | 262,144 | 5.08 | 3.62 | 1.40 |
| ModInt multiply and add | 2,097,152 | 4.48 | 4.49 | 1.00 |

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
