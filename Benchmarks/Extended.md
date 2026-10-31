# Extended workloads

Run `./run-extended.sh` from `Benchmarks`. Swift Release, C++ -O3 -DNDEBUG,
three cycles, powers-of-two sizes. Graph workloads have lower explicit caps;
2M is not an appropriate default for every algorithm. The per-element chart
reports batch time divided by N, **not** time per API call.

| Workload | Definition | Maximum N |
| --- | --- | ---: |
| Fenwick | N random add/prefix-sum pairs on an N-element tree | 2,097,152 |
| LazySegTree | N range-add(+1)/range-sum pairs on N zero cells | 262,144 |
| SCC | N vertices, rings of up to 16 vertices, plus up to N forward inter-group edges | 131,072 |
| TwoSAT | N variables, N planted satisfiable clauses; first literal follows the even-index assignment | 131,072 |
| MaxFlow | N intermediate vertices; source and sink edges with capacities 1...16; forward neighbor edges of capacity 8 | 32,768 |
| MinCostFlow | Same topology; source cost 0, sink cost 0...7, neighbor cost 1 | 1,024 |
| Convolution | Two length-N integer arrays, coefficients 0...99, modulo 998244353 | 262,144 |
| Suffix array | Length-N random integer symbols, alphabet 0...25, explicit upper bound | 262,144 |
| Z algorithm | Same length-N symbols | 262,144 |
| ModInt | N chained multiply/add pairs modulo 998244353 | 2,097,152 |

All inputs derive from the same seeded `Input` arrays as the initial run.
Construction, destruction, array preparation, algorithm execution and output
handling are included. SCC outputs canonical component labels (minimum vertex),
and that normalization is also timed on both sides. TwoSAT measures satisfiability,
not assignment extraction; its positive result is checked against the planted
solution. Flow workloads compare the total flow (and total cost for min-cost flow).

Swift uses Int; ACL uses native int for indices/strings and intptr_t for numeric
values/capacities. String symbol buffers therefore use 64-bit elements on Swift
and 32-bit on C++; this compares the exposed implementations, not equalized layouts.
Convolution and string results are assigned as Swift arrays; the C bridge copies
its result to a Swift output buffer. Both timed wrappers allocate an output buffer
initially, but Swift can replace it. Small-size differences include this wrapper
cost. C++ crosses the language boundary only once per entire batch.

Verification uses sizes 1, 2, 3, 17, 256, min(4096, maximum N), and maximum N, comparing every
returned output. SCC additionally checks known group labels; TwoSAT checks the
known satisfiable result. Performance is deliberately scoped to these workloads:
planted satisfiable 2-SAT, grouped SCCs and sparse flow networks do not establish
worst-case performance or behavior on arbitrary graphs.

Not covered yet: unsatisfiable 2-SAT, dense/adversarial graphs, alternate lazy
operators, dynamic ModInt, convolution_ll, standalone number-theory routines,
Unicode strings, and other input distributions. No product implementation was
changed to improve these results.
