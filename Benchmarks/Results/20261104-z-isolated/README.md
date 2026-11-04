# Z algorithm after benchmark isolation

Measured on 2026-11-04 from product revision `0958d35`, with the accompanying
`harness.diff` applied to the benchmark only. Apple M1, Swift 6.4 Release -O,
C++ -O3 -DNDEBUG, no sanitizers. Three cycles, up to 262,144 elements.

The Z workload was extracted into a non-inlined function to reduce interference
from optimization of unrelated switch cases. Input mapping, Z computation and
result lifetime remain inside the timed workload. Product code is unchanged.
The extended verification passed, and a separate build reproduced the recovery.

C++ is red; Swift is blue. The center is the mean of cycle minima; bands show
minimum and mean + 2 standard deviations, not confidence intervals.

The earlier roughly 4.9 ns/element plateau returned to roughly 3.6 ns/element.
At 262,144 elements, follow-up alternating measurements still showed a gap in
minimum times versus the old build; mean ranges overlapped. Its cause remains
unresolved. No claim of a general product regression is made.

Only Z was remeasured across the full size range. The other README charts retain
their [earlier measurement](../20261104-current/README.md).

![Z algorithm alphabet 26](<charts/01 Z algorithm alphabet 26.png>)
