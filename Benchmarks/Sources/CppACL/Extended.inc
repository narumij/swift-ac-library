#include "CppACL.h"
#include <atcoder/all>
#include <algorithm>
#include <vector>
using I = intptr_t;
struct Cell { I sum, count; };
Cell op(Cell a, Cell b) { return {a.sum+b.sum, a.count+b.count}; }
Cell e() { return {0,0}; }
Cell mapping(I f, Cell x) { return {x.sum+f*x.count,x.count}; }
I composition(I f, I g) { return f+g; }
I identity() { return 0; }
extern "C" void acl_extra(int kind, I n, const I *a, const I *b, I *out) {
  switch(kind) {
  case 0: {
    atcoder::fenwick_tree<I> t(n);
    for(I i=0;i<n;i++) { t.add(a[i],b[i]); out[i]=t.sum(0,a[i]+1); }
    break;
  }
  case 1: {
    atcoder::lazy_segtree<Cell,op,e,I,mapping,composition,identity> t(std::vector<Cell>(n,{0,1}));
    for(I i=0;i<n;i++) { int l=std::min(a[i],b[i]),r=std::max(a[i],b[i])+1; t.apply(l,r,1); out[i]=t.prod(l,r).sum; }
    break;
  }
  case 2: {
    atcoder::scc_graph g(n);
    for(I i=0;i<n;i++) {
      I start=i/16*16,end=std::min(start+16,n);
      g.add_edge(i,i+1<end ? i+1 : start);
      if(a[i]/16!=b[i]/16) g.add_edge(std::min(a[i],b[i]),std::max(a[i],b[i]));
    }
    for(auto group:g.scc()) { I label=*std::min_element(group.begin(),group.end()); for(int v:group) out[v]=label; }
    break;
  }
  case 3: {
    atcoder::two_sat g(n);
    for(I i=0;i<n;i++) g.add_clause(a[i],a[i]%2==0,b[i],i%2==0);
    out[0]=g.satisfiable(); break;
  }
  case 4: {
    atcoder::mf_graph<I> g(n+2);
    for(I i=0;i<n;i++) { g.add_edge(0,i+1,a[i]%16+1); g.add_edge(i+1,n+1,b[i]%16+1); if(i+1<n) g.add_edge(i+1,i+2,8); }
    out[0]=g.flow(0,n+1); break;
  }
  case 5: {
    atcoder::mcf_graph<I,I> g(n+2);
    for(I i=0;i<n;i++) { g.add_edge(0,i+1,a[i]%16+1,0); g.add_edge(i+1,n+1,b[i]%16+1,b[i]%8); if(i+1<n) g.add_edge(i+1,i+2,8,1); }
    auto result=g.flow(0,n+1); out[0]=result.first; out[1]=result.second; break;
  }
  case 6: {
    std::vector<I> x(n),y(n); for(I i=0;i<n;i++) { x[i]=a[i]%100; y[i]=b[i]%100; }
    auto result=atcoder::convolution(x,y); std::copy(result.begin(),result.end(),out); break;
  }
  case 7: case 8: {
    std::vector<int> text(n); for(I i=0;i<n;i++) text[i]=a[i]%26;
    auto result=kind==7 ? atcoder::suffix_array(text,25) : atcoder::z_algorithm(text);
    std::copy(result.begin(),result.end(),out); break;
  }
  case 9: {
    atcoder::modint998244353 x=1;
    for(I i=0;i<n;i++) { x=x*atcoder::modint998244353(a[i])+atcoder::modint998244353(b[i]);out[i]=x.val(); }
    break;
  }
  }
}
