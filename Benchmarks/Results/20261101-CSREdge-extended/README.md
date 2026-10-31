# CSR edge struct: benchmark rerun

Measured product revision: `c17ff6b`. Same workloads and settings as the earlier run; Swift Release -O, C++ -O3, no sanitizer, three cycles. Times are mean cycle minima, ns per input element.

Previous and current runs are separate sessions; changes include run-to-run variation. C++ current timings are included as a control. See [workload definitions](../../README.md) and [extended workload limits](../../Extended.md).

| Workload | Maximum N | Previous Swift | Current Swift | Current C++ | Swift/C++ |
| --- | ---: | ---: | ---: | ---: | ---: |
| Fenwick add and prefix sum | 2,097,152 | 45.4 | 52.7 | 49.9 | 1.06× |
| LazySegTree range add and sum | 262,144 | 434.6 | 474.0 | 420.8 | 1.13× |
| SCC grouped cycles | 131,072 | 72.4 | 50.0 | 38.3 | 1.31× |
| TwoSAT planted clauses | 131,072 | 114.2 | 99.5 | 68.3 | 1.46× |
| MaxFlow sparse network | 32,768 | 537.4 | 547.4 | 380.0 | 1.44× |
| MinCostFlow sparse network | 1,024 | 18672.4 | 19627.7 | 11369.2 | 1.73× |
| Convolution modulo 998244353 | 262,144 | 59.5 | 61.7 | 61.3 | 1.01× |
| Suffix array alphabet 26 | 262,144 | 52.4 | 56.1 | 42.8 | 1.31× |
| Z algorithm alphabet 26 | 262,144 | 4.0 | 4.3 | 3.6 | 1.19× |
| ModInt multiply and add | 2,097,152 | 4.4 | 4.6 | 4.7 | 0.98× |

Verification passed; see [verification output](verification.txt). No new algorithm changes were made for this rerun.

## Charts

### Fenwick add and prefix sum

![Fenwick add and prefix sum](<charts/01 Fenwick add and prefix sum.png>)

### LazySegTree range add and sum

![LazySegTree range add and sum](<charts/02 LazySegTree range add and sum.png>)

### SCC grouped cycles

![SCC grouped cycles](<charts/03 SCC grouped cycles.png>)

### TwoSAT planted clauses

![TwoSAT planted clauses](<charts/04 TwoSAT planted clauses.png>)

### MaxFlow sparse network

![MaxFlow sparse network](<charts/05 MaxFlow sparse network.png>)

### MinCostFlow sparse network

![MinCostFlow sparse network](<charts/06 MinCostFlow sparse network.png>)

### Convolution modulo 998244353

![Convolution modulo 998244353](<charts/07 Convolution modulo 998244353.png>)

### Suffix array alphabet 26

![Suffix array alphabet 26](<charts/08 Suffix array alphabet 26.png>)

### Z algorithm alphabet 26

![Z algorithm alphabet 26](<charts/09 Z algorithm alphabet 26.png>)

### ModInt multiply and add

![ModInt multiply and add](<charts/10 ModInt multiply and add.png>)
