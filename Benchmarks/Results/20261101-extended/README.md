# Extended Swift / C++ comparison — 2026-11-01

Swift Release -O; C++ -O3 -DNDEBUG; no sanitizer. Three cycles per size.
See [workload definitions and limitations](../../Extended.md) and [environment](environment.txt).

## Largest measured sizes

Times are nanoseconds per input element, averaged over the three cycle minima.
Ratios are Swift time / C++ time: lower is faster. Different workloads have different caps.

| Workload | Maximum N | C++ ns/input | Swift ns/input | Ratio |
| --- | ---: | ---: | ---: | ---: |
| Fenwick add and prefix sum | 2,097,152 | 45.1 | 45.4 | 1.01× |
| LazySegTree range add and sum | 262,144 | 392.1 | 434.6 | 1.11× |
| SCC grouped cycles | 131,072 | 37.3 | 72.4 | 1.94× |
| TwoSAT planted clauses | 131,072 | 57.7 | 114.2 | 1.98× |
| MaxFlow sparse network | 32,768 | 363.3 | 537.4 | 1.48× |
| MinCostFlow sparse network | 1,024 | 10872.3 | 18672.4 | 1.72× |
| Convolution modulo 998244353 | 262,144 | 58.7 | 59.5 | 1.01× |
| Suffix array alphabet 26 | 262,144 | 41.6 | 52.4 | 1.26× |
| Z algorithm alphabet 26 | 262,144 | 3.5 | 4.0 | 1.15× |
| ModInt multiply and add | 2,097,152 | 4.4 | 4.4 | 0.99× |

## Verification

All 69 size/workload checks passed, including each measured maximum. Returned outputs agree with C++; SCC labels and planted satisfiability also have independent checks. See [maximum-size verification](verification-max.txt). These checks cover the selected workloads, not every possible input.

Construction/destruction, output handling and wrapper overhead are timed. Native integer widths differ. Sparse graphs and planted satisfiable clauses do not characterize worst-case behavior. See the workload definitions before generalizing these results.

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
