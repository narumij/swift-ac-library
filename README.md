# swift-ac-library

English | [日本語](README.ja.md)
[Known limitations](KNOWN_LIMITATIONS.md)


A Swift port of [AC(AtCoder) Library][ac-library], the competitive programming library for [AtCoder][ac].

[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## Documentation

- [English API documentation (DocC)](https://narumij.github.io/swift-ac-library/documentation/atcoder/)
- [Japanese guide](Documentation/ja/README.md)

These guides cover Swift usage, constraints, complexity and examples. The
checked-in guides describe this source revision; the published site follows main.

## Official Information

[AtCoder Library (ACL) - AtCoder][acl]

## Usage

To use swift-ac-library with SwiftPM, add the following to your `Package.swift`:

```swift
dependencies: [
  .package(
    url: "https://github.com/narumij/swift-ac-library",
    branch: "compatible/AtCoder/2025"),
],
```

Then add the following dependency to your build target:

```swift
  dependencies: [
    .product(name: "AtCoder", package: "swift-ac-library")
    ]
```

Add the following import to your source code:

```swift
import AtCoder
```

## Branch Strategy

| Branch | Recommended | Status | Description |
|----------|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | Maintained | Recommended branch compatible with AtCoder 2025 |
| `release/AtCoder/2025` | | Frozen | Branch matching the version installed on AtCoder 2025 |
| `main` | | Active Development | Development branch for the next release |

### Which branch should I use?

In general, use `compatible/AtCoder/2025`.

`release/AtCoder/2025` preserves the exact state installed on AtCoder. As a rule, it is not changed.

The `compatible/AtCoder/2025` branch maintains compatibility with AtCoder 2025 while adding maintenance updates such as documentation improvements, deprecation annotations, and additional notices.

`main` is the development branch for the next release.

## Benchmarks

Swift / C++ AtCoder Library comparison measured from product revision `9d8e73e`
on Apple M1, Swift 6.4 Release -O, C++ -O3 -DNDEBUG, no sanitizers.
Values are end-to-end batch measurements, including construction, execution and
destruction. These specific inputs do not establish general performance rankings.
Bands are not confidence intervals.
See [the result summary](Benchmarks/Results/20261104-current/README.md),
[methodology](Benchmarks/README.md) and [workload definitions](Benchmarks/Extended.md).

### DSU merge and size

![DSU merge and size](Benchmarks/Results/20261104-current/charts/01%20DSU%20merge%20and%20size.png)

### SegTree random updates

![SegTree random updates](Benchmarks/Results/20261104-current/charts/02%20SegTree%20random%20updates.png)

### SegTree range sums

![SegTree range sums](Benchmarks/Results/20261104-current/charts/03%20SegTree%20range%20sums.png)

### Fenwick add and prefix sum

![Fenwick add and prefix sum](Benchmarks/Results/20261104-current/charts/04%20Fenwick%20add%20and%20prefix%20sum.png)

### LazySegTree range add and sum

![LazySegTree range add and sum](Benchmarks/Results/20261104-current/charts/05%20LazySegTree%20range%20add%20and%20sum.png)

### SCC grouped cycles

![SCC grouped cycles](Benchmarks/Results/20261104-current/charts/06%20SCC%20grouped%20cycles.png)

### TwoSAT planted clauses

![TwoSAT planted clauses](Benchmarks/Results/20261104-current/charts/07%20TwoSAT%20planted%20clauses.png)

### MaxFlow sparse network

![MaxFlow sparse network](Benchmarks/Results/20261104-current/charts/08%20MaxFlow%20sparse%20network.png)

### MinCostFlow sparse network

![MinCostFlow sparse network](Benchmarks/Results/20261104-current/charts/09%20MinCostFlow%20sparse%20network.png)

### Convolution modulo 998244353

![Convolution modulo 998244353](Benchmarks/Results/20261104-current/charts/10%20Convolution%20modulo%20998244353.png)

### Suffix array alphabet 26

![Suffix array alphabet 26](Benchmarks/Results/20261104-current/charts/11%20Suffix%20array%20alphabet%2026.png)

### Z algorithm alphabet 26

This chart uses the isolated Z benchmark at product revision `0958d35`; product code is unchanged. See [measurement details and limitations](Benchmarks/Results/20261104-z-isolated/README.md). C++ is red; Swift is blue.

![Z algorithm alphabet 26](Benchmarks/Results/20261104-z-isolated/charts/01%20Z%20algorithm%20alphabet%2026.png)

### ModInt multiply and add

![ModInt multiply and add](Benchmarks/Results/20261104-current/charts/13%20ModInt%20multiply%20and%20add.png)

## Related Projects

[ac-library-csharp] - C# version

[ac-library-python] - Python version

[ac-library-swift] - Original Swift version

## License

[CC0]



[ac]: https://atcoder.jp/

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/
