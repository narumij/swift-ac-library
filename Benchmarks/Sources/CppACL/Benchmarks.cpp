#include "CppACL.h"
#include <atcoder/dsu>
#include <atcoder/segtree>
#include <algorithm>
#include <vector>
using I = intptr_t;
I add(I a, I b) { return a + b; }
I zero() { return 0; }
extern "C" void acl_dsu(I n, const I *a, const I *b, I *out) {
  atcoder::dsu tree(static_cast<int>(n));
  for (I i = 0; i < n; ++i) {
    tree.merge(static_cast<int>(a[i]), static_cast<int>(b[i]));
    out[i] = tree.size(static_cast<int>(a[i]));
  }
}
extern "C" void acl_seg_update(I n, const I *a, const I *b, I *out) {
  atcoder::segtree<I, add, zero> tree(static_cast<int>(n));
  for (I i = 0; i < n; ++i) {
    tree.set(static_cast<int>(a[i]), b[i]);
    out[i] = tree.all_prod();
  }
}
extern "C" void acl_seg_query(I n, const I *a, const I *b, I *out) {
  // Construction is included on both sides; queries use a tree of unit values.
  atcoder::segtree<I, add, zero> tree(std::vector<I>(n, 1));
  for (I i = 0; i < n; ++i)
    out[i] = tree.prod(static_cast<int>(std::min(a[i], b[i])),
                       static_cast<int>(std::max(a[i], b[i]) + 1));
}

#include "Extended.inc"
