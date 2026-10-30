import AtCoder
import Foundation
struct Sum: SegTreeOperator {
 static var e: Int { 0 }
 static func op(_ a:Int,_ b:Int)->Int { a+b }
}
struct Cell { var sum:Int; var count:Int }
struct Affine { var a:Int; var b:Int }
enum Lazy: LazySegTreeOperator {
 static var e:Cell { Cell(sum:0,count:0) }
 static var id:Affine { Affine(a:1,b:0) }
 static func op(_ x:Cell,_ y:Cell)->Cell { Cell(sum:x.sum+y.sum,count:x.count+y.count) }
 static func mapping(_ f:Affine,_ x:Cell)->Cell { Cell(sum:f.a*x.sum+f.b*x.count,count:x.count) }
 static func composition(_ f:Affine,_ g:Affine)->Affine { Affine(a:f.a*g.a,b:f.a*g.b+f.b) }
}
while let line=readLine() {
 let tokens=line.split(separator:" ").map(String.init); var cursor=1; var out=[Int]()
 func next()->Int { defer {cursor+=1}; return Int(tokens[cursor])! }
 func array(_ n:Int)->[Int] { (0..<n).map{_ in next()} }
 switch tokens[0] {
 case "dsu":
  let n=next(), q=next(); var g=DSU(n)
  for _ in 0..<q { let op=next(),a=next(),b=next(); switch op {
   case 0: _=g.merge(a,b)
   case 1: out.append(g.same(a,b) ? 1:0)
   default: out.append(g.size(a))
  }}
  let groups=g.groups(); var labels=[Int](repeating:0,count:n)
  for group in groups { for v in group { labels[v]=group.min()! } }; out += labels
 case "fenwick":
  let n=next(), q=next(); var g=FenwickTree<Int>(n)
  for _ in 0..<q { let op=next(),a=next(),b=next(); if op==0 { g.add(a,b) } else { out.append(g.sum(a,b)) } }
 case "seg":
  let n=next(),q=next(); var g=SegTree<Sum>(array(n))
  for _ in 0..<q { let op=next(),a=next(),b=next(); switch op {
  case 0:g.set(a,b)
  case 1:out.append(g.prod(a,b))
  case 2:out.append(g.get(a))
  case 3:out.append(g.max_right(a){$0<=b})
  case 4:out.append(g.min_left(a){$0<=b})
  default:out.append(g.all_prod())
  }}
 case "lazy":
  let n=next(),q=next(); var g=LazySegTree<Lazy>(array(n).map{Cell(sum:$0,count:1)})
  for _ in 0..<q { let op=next(),a=next(),b=next(),c=next(),d=next(); switch op {
   case 0:g.apply(a,b,Affine(a:c,b:d))
   case 1:out.append(g.prod(a,b).sum)
   case 2:g.set(a,Cell(sum:b,count:1))
   case 3:out.append(g.get(a).sum)
   case 4:out.append(g.max_right(a){$0.sum<=b})
   case 5:out.append(g.min_left(a){$0.sum<=b})
   case 6:g.apply(a,Affine(a:c,b:d))
   default:out.append(g.all_prod().sum)
  }}
 case "scc":
  let n=next(),m=next(); var g=SCCGraph(n); var edges=[(Int,Int)]()
  for _ in 0..<m {let a=next(),b=next(); g.add_edge(a,b);edges.append((a,b))}
  let groups=g.scc(); var ids=[Int](repeating:0,count:n), labels=ids
  for (i,group) in groups.enumerated() {for v in group {ids[v]=i; labels[v]=group.min()!}}
  for (a,b) in edges {precondition(ids[a]<=ids[b])};out=labels
 case "sat":
  let n=next(),m=next();var g=TwoSAT(n);var clauses=[(Int,Bool,Int,Bool)]()
  for _ in 0..<m {let a=next(),f=next() != 0,b=next(),h=next() != 0;g.add_clause(a,f,b,h);clauses.append((a,f,b,h))}
  let ok=g.satisfiable();if ok {let answer=g.answer();for (a,f,b,h) in clauses {precondition(answer[a]==f || answer[b]==h)}};out=[ok ? 1:0]
 case "flow":
  let n=next(),m=next(),limit=next();var g=MFGraph<Int>(count:n)
  for _ in 0..<m {_=g.add_edge(next(),next(),next())}
  let first=g.flow(0,n-1,limit),rest=g.flow(0,n-1);out=[first,rest]
  var balance=[Int](repeating:0,count:n);var cut=0;let reachable=g.min_cut(0)
  for e in g.edges() {precondition(e.flow>=0 && e.flow<=e.cap);balance[e.from]-=e.flow;balance[e.to]+=e.flow;if reachable[e.from] && !reachable[e.to] {cut+=e.cap}}
  precondition(balance[0] == -(first+rest) && balance[n-1]==first+rest && cut==first+rest)
  for v in 1..<(n-1) {precondition(balance[v]==0)}
 case "flowedit":
  let n=next(),m=next(),q=next();var g=MFGraph<Int>(count:n)
  for i in 0..<m {precondition(g.add_edge(next(),next(),next())==i)}
  out.append(g.flow(0,n-1))
  for _ in 0..<q {
   let index=next(),cap=next()
   // 既存の流れを全辺でゼロに戻し、実行可能性を保って容量を変更する。
   for i in 0..<m {let e=g.get_edge(i);g.change_edge(i,i==index ? cap:e.cap,0)}
   let e=g.get_edge(index);out += [e.from,e.to,e.cap,e.flow]
   out.append(g.flow(0,n-1))
   for (i,e) in g.edges().enumerated(){let x=g.get_edge(i);precondition(e.from==x.from && e.to==x.to && e.cap==x.cap && e.flow==x.flow)}
  }
 case "divide":
  let m=next(),a=next(),b=next();modint.set_mod(m)
  let x=modint(a),y=modint(b);let raw=modint(rawValue:UInt(y.val))
  out=[y.inv.val,(x/y).val,raw.val,(x/raw).val]
 case "staticdivide":
  let a=next(),b=next();let x=modint998244353(a),y=modint998244353(b)
  let raw=modint998244353(rawValue:UInt(y.val));out=[y.inv.val,(x/y).val,raw.val,(x/raw).val]
 case "cost":
  let n=next(),m=next(),limit=next();var g=MCFGraph<Int,Int>(count:n)
  var limited=MCFGraph<Int,Int>(count:n);var full=MCFGraph<Int,Int>(count:n);var fullSlope=MCFGraph<Int,Int>(count:n)
  for i in 0..<m {let a=next(),b=next(),c=next(),d=next();precondition(g.add_edge(a,b,c,d)==i);_=limited.add_edge(a,b,c,d);_=full.add_edge(a,b,c,d);_=fullSlope.add_edge(a,b,c,d)}
  let slope=g.slope(0,n-1,limit);out=slope.flatMap{[$0.0,$0.1]}
  let end=slope.last!;let l=limited.flow(0,n-1,limit);precondition(l.0==end.0 && l.1==end.1)
  let f=full.flow(0,n-1),fs=fullSlope.slope(0,n-1).last!;precondition(f.0==fs.0 && f.1==fs.1)
  var balance=[Int](repeating:0,count:n);var cost=0
  for e in g.edges(){precondition(e.flow>=0 && e.flow<=e.cap);balance[e.from]-=e.flow;balance[e.to]+=e.flow;cost+=e.flow*e.cost}
  precondition(balance[0] == -end.0 && balance[n-1]==end.0 && cost==end.1)
  for v in 1..<(n-1){precondition(balance[v]==0)}
 case "math":
  let op=next(); switch op {
  case 0:out=[pow_mod(next(),next(),next())]
  case 1:out=[inv_mod(next(),next())]
  case 2:out=[floor_sum(next(),next(),next(),next())]
  default:let n=next(),r=array(n),m=array(n);let ans=crt(r,m);out=[ans.rem,ans.mod]
  }
 case "mod":
  let modulus=next(),a=next(),b=next(),power=next();modint.set_mod(modulus)
  let x=modint(a),y=modint(b)
  out=[x.val,y.val,(x+y).val,(x-y).val,(x*y).val,x.pow(power).val,(-x).val]
 case "staticmod":
  let a=next(),b=next(),power=next();let x=modint998244353(a),y=modint998244353(b)
  out=[x.val,y.val,(x+y).val,(x-y).val,(x*y).val,x.pow(power).val,(-x).val]
 case "conv":
  let n=next(),m=next(),a=array(n),b=array(m);out=convolution(mod_998_244_353.self,a,b)
 case "convll":
  let n=next(),m=next(),a=array(n),b=array(m);out=convolution_ll(a,b)
 case "string":
  let n=next(),upper=next(),s=array(n);let sa=suffix_array(s,upper)
  precondition(sa==suffix_array(s));out=sa
  if n>0 {out+=lcp_array(s,sa)};out+=z_algorithm(s)
 default:fatalError("unknown case")
 }
 precondition(cursor==tokens.count)
 print(out.map(String.init).joined(separator:" "))
}
