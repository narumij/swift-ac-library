#include "CppACL.h"
#include <atcoder/maxflow>
using Graph = atcoder::mf_graph<intptr_t>;
extern "C" void *acl_flow_create(intptr_t n, const intptr_t *a, const intptr_t *b) {
  auto *g = new Graph(static_cast<int>(n + 2));
  for (intptr_t i = 0; i < n; ++i) {
    g->add_edge(0, static_cast<int>(i + 1), a[i] % 16 + 1);
    g->add_edge(static_cast<int>(i + 1), static_cast<int>(n + 1), b[i] % 16 + 1);
    if (i + 1 < n) g->add_edge(static_cast<int>(i + 1), static_cast<int>(i + 2), 8);
  }
  return g;
}
extern "C" intptr_t acl_flow_run(void *graph, intptr_t n) {
  return static_cast<Graph *>(graph)->flow(0, static_cast<int>(n + 1));
}
extern "C" void acl_flow_destroy(void *graph) { delete static_cast<Graph *>(graph); }
