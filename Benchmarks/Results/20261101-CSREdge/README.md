# CSR edge struct: benchmark rerun

Measured product revision: `c17ff6b`. Same workloads and settings as the earlier run; Swift Release -O, C++ -O3, no sanitizer, three cycles. Times are mean cycle minima, ns per input element.

Previous and current runs are separate sessions; changes include run-to-run variation. C++ current timings are included as a control. See [workload definitions](../../README.md) and [extended workload limits](../../Extended.md).

| Workload | Maximum N | Previous Swift | Current Swift | Current C++ | Swift/C++ |
| --- | ---: | ---: | ---: | ---: | ---: |
| DSU merge and size | 2,097,152 | 27.9 | 26.5 | 28.1 | 0.95× |
| SegTree random updates | 2,097,152 | 114.7 | 115.5 | 85.0 | 1.36× |
| SegTree range sums | 2,097,152 | 106.9 | 106.1 | 105.1 | 1.01× |

Verification passed; see [verification output](verification.txt). No new algorithm changes were made for this rerun.

## Charts

### DSU merge and size

![DSU merge and size](<charts/01 DSU merge and size.png>)

### SegTree random updates

![SegTree random updates](<charts/02 SegTree random updates.png>)

### SegTree range sums

![SegTree range sums](<charts/03 SegTree range sums.png>)
