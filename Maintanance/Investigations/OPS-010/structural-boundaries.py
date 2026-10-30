import pathlib,subprocess,json,itertools,collections
root=pathlib.Path(__file__).resolve().parent;M=2**63-1;cases=[]
def flat(xs):return list(itertools.chain.from_iterable(xs))
def add(mode,args,out):cases.append(dict(mode=mode,input=' '.join(map(str,[mode,*args])),expected=' '.join(map(str,out))))
for n in [0,1,2,7,8,9,31,32,33,255,256,257]:
 a=[0]*n
 if n:a[-1]=M
 for mode in ['seg','lazy']:
  ops=[];out=[]
  for l in range(n+1):
   for r in sorted({l,n}):ops.append([1,l,r]+([0,0]if mode=='lazy'else[]));out.append(sum(a[l:r]))
   for threshold in [0,M]:
    r=l;s=0
    while r<n and s+a[r]<=threshold:s+=a[r];r+=1
    ops.append([4 if mode=='lazy'else 3,l,threshold]+([0,0]if mode=='lazy'else[]));out.append(r)
    r=l;s=0
    while r>0 and s+a[r-1]<=threshold:r-=1;s+=a[r]
    ops.append([5 if mode=='lazy'else 4,l,threshold]+([0,0]if mode=='lazy'else[]));out.append(r)
  if mode=='lazy':
   ops.extend([[0,0,n,0,0],[1,0,n,0,0],[0,0,n,1,1],[1,0,n,0,0]]);out.extend([0,n])
  add(mode,[n,len(ops),*a,*flat(ops)],out)
 ops=[[1,i,i]for i in range(n+1)];out=[0]*(n+1)
 if n:ops.extend([[0,n-1,M],[1,0,n]]);out.append(M)
 add('fenwick',[n,len(ops),*flat(ops)],out)
for n in [0,1,2,9,10,39,40,41,127,128,257]:
 for s in [[0]*n,[i%2 for i in range(n)],list(range(n)),list(reversed(range(n)))]:
  sa=sorted(range(n),key=lambda i:s[i:])
  def common(i,j):
   k=0
   while max(i,j)+k<n and s[i+k]==s[j+k]:k+=1
   return k
  add('string',[n,max(s,default=0),*s],sa+[common(i,j)for i,j in zip(sa,sa[1:])]+[common(0,i)for i in range(n)])
for n in [0,1,2,32,1000]:
 for cycle in [False,True]:
  edges=[(i,i+1)for i in range(n-1)]+([(n-1,0)]if n and cycle else[])
  add('scc',[n,len(edges),*flat(edges)],[0]*n if cycle else list(range(n)))
 ops=[[0,i,i+1]for i in range(n-1)]
 add('dsu',[n,len(ops),*flat(ops)],[0]*n)
for n in [0,1,2,32,1000]:
 clauses=[(i,1,i,1)for i in range(n)];add('sat',[n,len(clauses),*flat(clauses)],[1])
 if n:clauses.append((n-1,0,n-1,0));add('sat',[n,len(clauses),*flat(clauses)],[0])
for c in [0,1,M//4,M//2]:
 edges=[(0,1,c),(0,2,c),(1,2,c),(1,3,c),(2,3,c)]
 for limit in [0,1,2*c]:add('flow',[4,len(edges),limit,*flat(edges)],[min(limit,2*c),2*c-min(limit,2*c)])
for c in [0,1,2,M//8]:
 # Two disjoint routes with unit costs 2 and 3, total cost 5c fits.
 edges=[(0,1,c,1),(1,3,c,1),(0,2,c,1),(2,3,c,2)]
 for limit in [0,1,c,2*c]:
  f=min(limit,2*c);out=[0,0]
  if f:out += [min(f,c),2*min(f,c)]
  if f>c:out += [f,2*c+3*(f-c)]
  add('cost',[4,len(edges),limit,*flat(edges)],out)
bins={'cpp-debug':root/'cpp-debug','cpp-release':root/'cpp-release','swift-debug':root/'swift/.build/debug/Compare','swift-release':root/'swift/.build/release/Compare'}
results=[]
for case in cases:
 for name,exe in bins.items():
  try:
   r=subprocess.run([str(exe)],input=case['input']+'\n',text=True,capture_output=True,timeout=20)
   results.append(dict(case=len(results)//4,build=name,exit=r.returncode,ok=r.returncode==0 and r.stdout.strip()==case['expected'],stdout=r.stdout if r.returncode or r.stdout.strip()!=case['expected'] else None))
  except subprocess.TimeoutExpired:results.append(dict(case=len(results)//4,build=name,exit='timeout',ok=False))
(root/'structural-boundary-results.json').write_text(json.dumps(dict(cases=cases,results=results),indent=2)+'\n')
print('cases',len(cases),'runs',len(results),'groups',dict(collections.Counter(c['mode']for c in cases)))
for name in bins:
 bad=[x for x in results if x['build']==name and not x['ok']];print(name,bad[:10],len(bad))
