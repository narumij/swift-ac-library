# Initial comparison, 2026-11-01 (JST)

Apple M1, macOS 27.0.1, Apple Swift 6.4 / Apple Clang 21.
Swift Release, C++ **-O3 -DNDEBUG**, no sanitizer.
Swift source: `29d225e4d66406d25832f6f4ca7079db4b897f37`.
C++ ACL: `864245a00b00dd008d1abfdc239618fdb7d139da`.

Mean of three cycle minima at **2,097,152 elements**, ns per input element.
These include construction/destruction and result-array handling; see the
[workload and timing definitions](../../README.md). DSU and update batches
perform two API calls per element. Ratios are Swift / C++ (lower is faster).

| Workload | Swift ns | C++ ns | Ratio |
| --- | ---: | ---: | ---: |
| DSU merge and size | 27.9 | 28.2 | 0.99 |
| SegTree random updates | 114.7 | 84.8 | 1.35 |
| SegTree range sums | 106.9 | 105.5 | 1.01 |

All six tasks completed every selected size through 2M with three samples each.
The separate verification passed all 21 workload/size combinations (sizes 1,
2, 3, 17, 256, 4096, 65536), comparing every output element. Range sums also
passed the independent unit-array oracle. No claim is made for other workloads.

The earlier size-optimized C++ trial is superseded by this -O3 run; it is retained
privately under Maintanance/Investigations/OPS-013/initial-Os.

![01 DSU merge and size](<charts/01 DSU merge and size.png>)

![02 SegTree random updates](<charts/02 SegTree random updates.png>)

![03 SegTree range sums](<charts/03 SegTree range sums.png>)
