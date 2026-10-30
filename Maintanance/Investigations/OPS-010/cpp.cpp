#include <array>

#include <atcoder/dsu>
#include <atcoder/fenwicktree>
#include <atcoder/segtree>
#include <atcoder/lazysegtree>
#include <atcoder/scc>
#include <atcoder/twosat>
#include <atcoder/maxflow>
#include <atcoder/mincostflow>
#include <atcoder/math>
#include <atcoder/modint>
#include <atcoder/convolution>
#include <atcoder/string>
#include <iostream>
#include <sstream>
#include <string>
#include <algorithm>
using namespace std; using namespace atcoder; using I=long long;
I sumop(I a,I b){return a+b;} I zero(){return 0;}
struct Cell{I sum,count;};struct Affine{I a,b;};
Cell op(Cell a,Cell b){return {a.sum+b.sum,a.count+b.count};} Cell e(){return {0,0};}
Cell mapping(Affine f,Cell x){return {f.a*x.sum+f.b*x.count,x.count};}
Affine composition(Affine f,Affine g){return {f.a*g.a,f.a*g.b+f.b};} Affine id(){return {1,0};}
int main(){string line;while(getline(cin,line)){istringstream in(line);string mode;in>>mode;vector<I> out;
 auto next=[&](){I v;in>>v;assert(in);return v;};auto arr=[&](int n){vector<I> v(n);for(auto &x:v)x=next();return v;};
 if(mode=="dsu"){int n=next(),q=next();dsu g(n);for(int i=0;i<q;i++){int o=next(),a=next(),b=next();if(o==0)g.merge(a,b);else if(o==1)out.push_back(g.same(a,b));else out.push_back(g.size(a));}vector<I> labels(n);for(auto group:g.groups())for(auto v:group)labels[v]=*min_element(group.begin(),group.end());out.insert(out.end(),labels.begin(),labels.end());}
 else if(mode=="fenwick"){int n=next(),q=next();fenwick_tree<I> g(n);for(int i=0;i<q;i++){int o=next(),a=next();I b=next();if(o==0)g.add(a,b);else out.push_back(g.sum(a,b));}}
 else if(mode=="seg"){int n=next(),q=next();segtree<I,sumop,zero> g(arr(n));for(int i=0;i<q;i++){int o=next(),a=next();I b=next();if(o==0)g.set(a,b);else if(o==1)out.push_back(g.prod(a,b));else if(o==2)out.push_back(g.get(a));else if(o==3)out.push_back(g.max_right(a,[&](I v){return v<=b;}));else if(o==4)out.push_back(g.min_left(a,[&](I v){return v<=b;}));else out.push_back(g.all_prod());}}
 else if(mode=="lazy"){int n=next(),q=next();vector<Cell> v;for(auto x:arr(n))v.push_back({x,1});lazy_segtree<Cell,op,e,Affine,mapping,composition,id> g(v);for(int i=0;i<q;i++){int o=next(),a=next();I b=next(),c=next(),d=next();if(o==0)g.apply(a,b,{c,d});else if(o==1)out.push_back(g.prod(a,b).sum);else if(o==2)g.set(a,{b,1});else if(o==3)out.push_back(g.get(a).sum);else if(o==4)out.push_back(g.max_right(a,[&](Cell v){return v.sum<=b;}));else if(o==5)out.push_back(g.min_left(a,[&](Cell v){return v.sum<=b;}));else if(o==6)g.apply(a,{c,d});else out.push_back(g.all_prod().sum);}}
 else if(mode=="scc"){int n=next(),m=next();scc_graph g(n);vector<pair<int,int>> edges;for(int i=0;i<m;i++){int a=next(),b=next();g.add_edge(a,b);edges.push_back({a,b});}vector<I> labels(n),ids(n);auto groups=g.scc();for(int i=0;i<(int)groups.size();i++)for(int v:groups[i]){labels[v]=*min_element(groups[i].begin(),groups[i].end());ids[v]=i;}for(auto [a,b]:edges)assert(ids[a]<=ids[b]);out=labels;}
 else if(mode=="sat"){int n=next(),m=next();two_sat g(n);vector<array<int,4>> clauses;for(int i=0;i<m;i++){int a=next(),f=next(),b=next(),h=next();g.add_clause(a,f,b,h);clauses.push_back({a,f,b,h});}bool ok=g.satisfiable();if(ok){auto a=g.answer();for(auto c:clauses)assert(a[c[0]]==c[1]||a[c[2]]==c[3]);}out={ok};}
 else if(mode=="flow"){int n=next(),m=next();I limit=next();mf_graph<I> g(n);for(int i=0;i<m;i++){int a=next(),b=next();I c=next();g.add_edge(a,b,c);}I first=g.flow(0,n-1,limit),rest=g.flow(0,n-1);out={first,rest};auto reachable=g.min_cut(0);vector<I> bal(n);I cut=0;for(auto e:g.edges()){assert(e.flow>=0&&e.flow<=e.cap);bal[e.from]-=e.flow;bal[e.to]+=e.flow;if(reachable[e.from]&&!reachable[e.to])cut+=e.cap;}assert(bal[0]==-first-rest&&bal[n-1]==first+rest&&cut==first+rest);for(int i=1;i<n-1;i++)assert(bal[i]==0);}
 else if(mode=="flowedit"){int n=next(),m=next(),q=next();mf_graph<I>g(n);for(int i=0;i<m;i++){int a=next(),b=next();I c=next();assert(g.add_edge(a,b,c)==i);}out.push_back(g.flow(0,n-1));for(int k=0;k<q;k++){int index=next();I cap=next();for(int i=0;i<m;i++){auto e=g.get_edge(i);g.change_edge(i,i==index?cap:e.cap,0);}auto e=g.get_edge(index);out.insert(out.end(),{e.from,e.to,e.cap,e.flow});out.push_back(g.flow(0,n-1));auto es=g.edges();for(int i=0;i<m;i++){auto x=g.get_edge(i),y=es[i];assert(x.from==y.from&&x.to==y.to&&x.cap==y.cap&&x.flow==y.flow);}}}
 else if(mode=="divide"){int m=next();I a=next(),b=next();modint::set_mod(m);modint x=a,y=b,raw=modint::raw(y.val());out={y.inv().val(),(x/y).val(),raw.val(),(x/raw).val()};}
 else if(mode=="staticdivide"){I a=next(),b=next();modint998244353 x=a,y=b,raw=modint998244353::raw(y.val());out={y.inv().val(),(x/y).val(),raw.val(),(x/raw).val()};}
 else if(mode=="cost"){int n=next(),m=next();I limit=next();mcf_graph<I,I> g(n),limited(n),full(n),fullSlope(n);for(int i=0;i<m;i++){int a=next(),b=next();I c=next(),d=next();g.add_edge(a,b,c,d);limited.add_edge(a,b,c,d);full.add_edge(a,b,c,d);fullSlope.add_edge(a,b,c,d);}auto slope=g.slope(0,n-1,limit);for(auto [f,c]:slope){out.push_back(f);out.push_back(c);}auto end=slope.back();assert(limited.flow(0,n-1,limit)==end);assert(full.flow(0,n-1)==fullSlope.slope(0,n-1).back());vector<I> bal(n);I cost=0;for(auto e:g.edges()){assert(e.flow>=0&&e.flow<=e.cap);bal[e.from]-=e.flow;bal[e.to]+=e.flow;cost+=e.flow*e.cost;}assert(bal[0]==-end.first&&bal[n-1]==end.first&&cost==end.second);for(int i=1;i<n-1;i++)assert(bal[i]==0);}
 else if(mode=="math"){int o=next();if(o==0){I x=next(),n=next();int m=next();out={pow_mod(x,n,m)};}else if(o==1){I x=next(),m=next();out={inv_mod(x,m)};}else if(o==2){I n=next(),m=next(),a=next(),b=next();out={floor_sum(n,m,a,b)};}else{int n=next();auto r=arr(n),m=arr(n);auto v=crt(r,m);out={v.first,v.second};}}
 else if(mode=="mod"){int m=next();I a=next(),b=next(),p=next();modint::set_mod(m);modint x=a,y=b;out={x.val(),y.val(),(x+y).val(),(x-y).val(),(x*y).val(),x.pow(p).val(),(-x).val()};}
 else if(mode=="staticmod"){I a=next(),b=next(),p=next();modint998244353 x=a,y=b;out={x.val(),y.val(),(x+y).val(),(x-y).val(),(x*y).val(),x.pow(p).val(),(-x).val()};}
 else if(mode=="conv"||mode=="convll"){int n=next(),m=next();auto a=arr(n),b=arr(m);out=mode=="conv"?convolution(a,b):convolution_ll(a,b);}
 else if(mode=="string"){int n=next(),upper=next();vector<int>s;for(auto x:arr(n))s.push_back(x);auto sa=suffix_array(s,upper);assert(sa==suffix_array(s));for(auto x:sa)out.push_back(x);if(n)for(auto x:lcp_array(s,sa))out.push_back(x);for(auto x:z_algorithm(s))out.push_back(x);}
 else abort();
 string extra;assert(!(in>>extra));for(size_t i=0;i<out.size();i++){if(i)cout<<' ';cout<<out[i];}cout<<'\n';
}}
