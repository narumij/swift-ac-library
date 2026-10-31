# Swift / C++ AtCoder Library benchmarks

Uses [swift-collections-benchmark](https://github.com/apple/swift-collections-benchmark),
following the chart workflow used by swift-ac-collections.
The benchmark package is separate from the library's products and tests.

## Run

On macOS with Swift 6.2 or newer and a C++17 compiler:

```sh
cd Benchmarks
./run.sh
# Optional larger run:
MAX_SIZE=16M CYCLES=3 ./run.sh Results/large
```

The bootstrap script fetches C++ AtCoder Library at revision
`864245a00b00dd008d1abfdc239618fdb7d139da` into the ignored `.build` directory.
The benchmark framework is pinned in `Package.swift`; dependency resolutions
are copied into every result directory. PNG rendering uses the framework's
macOS renderer. Swift uses Release -O; C++ explicitly uses -O3 -DNDEBUG (overriding the
size-oriented default of the Xcode build system). No sanitizer is enabled.
No unchecked Swift optimization is used. The default maximum size is 2M.

## Coverage

| Chart | One batch at size N |
| --- | --- |
| DSU merge and size | Construct N elements; perform N random merge/size pairs; destroy |
| SegTree random updates | Construct N zero values; perform N random set/all_prod pairs; destroy |
| SegTree range sums | Construct N unit values; perform N random nonempty range sums; destroy |

Inputs are generated outside timing using SplitMix64 with seed `0xAC12026`.
Each Swift/C++ pair receives the same two arrays. Ranges include both selected
endpoints. Each batch starts fresh; repeated measurements do not reuse a mutated
tree. The C bridge crosses once per batch, never once per tree operation.

**These are end-to-end batch measurements, including tree construction/destruction,
result-array allocation/writes and wrapper overhead.** They are not isolated
hot-path measurements. The chart's time per element is batch time divided by N:
for DSU and updates this includes two API calls per element. Swift uses Int
(64-bit on this machine), C++ uses intptr_t for values and ACL's native int
indices; DSU storage therefore differs (Swift 64-bit, C++ 32-bit). These are the
libraries' existing public implementations, not artificially equalized layouts.

Before timing, `benchmark verify` compares every returned value at sizes
1, 2, 3, 17, 256, 4096 and 65536. Range sums also have an independent unit-array
oracle. This validates these workloads, not the entire libraries.

Results include raw samples, environment/revision information, verification
output and PNGs. The framework reports a best measurement per cycle after
repeating the batch; bands across cycles are not a confidence interval.
Small-size results are particularly sensitive to allocation/bridge overhead.
Do not infer general superiority or sanitizer safety from these charts.

Ten additional workloads cover FenwickTree, LazySegTree, SCC/2-SAT, max/min-cost
flow, static ModInt, convolution, suffix arrays and the Z algorithm. `./run.sh` runs all thirteen workloads together; see [definitions and remaining coverage](Extended.md).

The unified runner uses powers-of-two sizes and each workload’s individual cap.
It verifies both groups, writes one results file, and renders all thirteen charts.
Older split result directories are retained as historical measurements.

## Recorded results

- [Suffix array: buffer borrowing and unchecked arithmetic](Results/20261101-suffix/README.md)

- [Latest: all thirteen charts after overflow-check removal](Results/20261101-overflow-updated/README.md)
- [Previous unified run](Results/20261101-unified/README.md)

- [CSR edge struct: initial three workloads](Results/20261101-CSREdge/README.md)
- [CSR edge struct: ten extended workloads](Results/20261101-CSREdge-extended/README.md)

- [2026-11-01: ten additional workloads](Results/20261101-extended/README.md)

- [2026-11-01: three workloads through 2M](Results/20261101-O3/README.md)

To use the exact dependency versions of this run, copy
`Results/20261101-O3/Package.resolved.json` to `Package.resolved` before building.
