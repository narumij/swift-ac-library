#pragma once
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
// Each call executes a complete batch; there is no per-operation FFI crossing.
void acl_dsu(intptr_t n, const intptr_t *a, const intptr_t *b, intptr_t *out);
void acl_seg_update(intptr_t n, const intptr_t *a, const intptr_t *b, intptr_t *out);
void acl_seg_query(intptr_t n, const intptr_t *a, const intptr_t *b, intptr_t *out);
void acl_extra(int kind, intptr_t n, const intptr_t *a, const intptr_t *b, intptr_t *out);
#ifdef __cplusplus
}
#endif
