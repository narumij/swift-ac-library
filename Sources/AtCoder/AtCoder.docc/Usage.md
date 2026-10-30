# Using the Swift library

Read the Swift conventions, arithmetic requirements, and graph semantics before choosing an algorithm.

## Install and import

This documentation describes the accompanying development source, whose
manifest requires Swift 6.2 or later. It does not describe the frozen version
installed on AtCoder 2025. Select your dependency branch deliberately:
`compatible/AtCoder/2025` is the maintained competition-compatible branch;
`release/AtCoder/2025` is the frozen installed version; `main` is development.

For the development API described here, add this package dependency:

```swift
.package(url: "https://github.com/narumij/swift-ac-library", branch: "main")
```

Add `.product(name: "AtCoder", package: "swift-ac-library")` to your target's
dependencies, then write `import AtCoder`. There are no C++ headers to include.
Judge installations may expose an older API; check that judge's installed
version rather than assuming the latest documentation applies.

## Indices, ranges, and types

Indices are zero-based Int values. Range operations use half-open intervals
[l,r): include l and exclude r. Empty ranges are allowed where stated.
Counts must be nonnegative; the original 10^8 upper bounds are input contracts,
not a promise that those allocations fit the machine's memory.

The examples use Int on a 64-bit host. C++ int corresponds to Int32, and C++
long long to Int64; translating either name to Swift Int does not extend the
algorithm's numeric range. Bounds, capacities, products and intermediate
calculations must fit their documented types. Out-of-contract input is not
supported. Debug assertions are not a validation API and may disappear in
Release; do not rely on a particular failure mode.

The guides' API blocks show calls using already defined arguments; their final
Example sections include concrete inputs. Generic types are inferred where
possible. Flow edge types are written `MFGraph<Int>.Edge` and
`MCFGraph<Int, Int>.Edge`; their fields are from, to, cap, flow, and (for MCF) cost.

## Ownership and mutation

DSU, FenwickTree, SegTree, LazySegTree, MFGraph, MCFGraph, SCCGraph, and TwoSAT
are noncopyable. Use var for mutating operations. Passing one by value transfers
ownership; it does not implicitly create an independent copy.

DSU, FenwickTree, SegTree, and LazySegTree expose `clone()` for an independent
O(n) copy. Other graph types do not currently expose a public clone method.
A parameter declared `borrowing` reads a value without consuming it; `inout`
permits mutation. LazySegTree reads may push pending updates and are mutating.
Default constructors create empty structures; valid empty operations remain
subject to each API's index requirements.

## Algebra and finite machine values

SegTree requires an associative operation and a two-sided identity; it need not
be commutative. LazySegTree additionally requires identity and composable maps
that preserve the operation: mapping(f,op(x,y)) = op(mapping(f,x),mapping(f,y)).
Composition means applying the second map, then the first.

The mathematical domain may be infinite while storage is finite. Every
contiguous aggregate that can arise must remain representable. For lazy
updates, every contiguous composition of updates applied to an element must
also remain representable. A final answer fitting Int does not imply that all
intermediates do. Sentinel values representing infinity must retain their
meaning under updates; blindly adding to Int.min or Int.max can overflow.

Complexities assume constant-time arithmetic, comparisons and callbacks.
Multiply by their cost for larger custom values; Unicode comparisons may
depend on character size.

## Maximum-flow state

Each edge stores capacity c and flow f, with 0 ≤ f ≤ c. Its residual graph
contains a forward edge when f < c and a backward edge when f > 0.
flow(s,t) augments this existing state, preserving net inflow at every vertex
except s and t. Its return value is the increase in net inflow at t.
A flow limit bounds that increase, not the accumulated total.

min_cut(s) returns vertices reachable in the current residual graph. It is a
minimum s–t cut after a complete maximum-flow solve from a feasible initial
state, not merely after an arbitrary limited-flow call.
change_edge changes only one edge: it does not rebalance other vertices.
Maintain a feasible flow yourself when editing it.
Unlike maximum flow, minimum-cost flow/slope must not be called repeatedly
on the same graph.

## Concurrent use and sanitizer coverage

Mutable shared moduli and convolution caches require care; sanitizer success
does not certify arbitrary concurrent use. Current sanitizer CI excludes
child-process exit tests. TSan additionally excludes both DSU implementations
and minimum-cost flow because of compiler failures; normal and ASan builds
retain them. Measurement bodies run ten iterations again. These are test
coverage limits, not new algorithm guarantees.

## Version-specific fixes

The development source fixes narrow-integer ModInt construction and
floor_sum negative-coefficient boundary arithmetic. Older installed versions
may still contain those defects. See the ModInt and Math chapters for the
relevant conditions and use the matching version's documentation.

## Documentation provenance

The algorithm contracts are adapted from the English and Japanese AtCoder
Library documentation at revision
`864245a00b00dd008d1abfdc239618fdb7d139da` (CC0-1.0).
Swift signatures, ownership notes and examples are local adaptations.
Upstream links are attribution, not prerequisites for using these guides.
