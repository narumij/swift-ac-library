import pathlib,subprocess,json,math
root=pathlib.Path(__file__).resolve().parent
M=2**63-1; L=-2**63
cases=[]
def add(s,e):cases.append((s,' '.join(map(str,e))))
def floor(n,m,a,b):
 q,a=divmod(a,m);r,b=divmod(b,m);ans=q*n*(n-1)//2+r*n
 while True:
  q,a=divmod(a,m);r,b=divmod(b,m);ans+=q*n*(n-1)//2+r*n
  y=a*n+b
  if y<m:return ans
  n,b=divmod(y,m);m,a=a,m
for x in [L,L+1,-1,0,1,M-1,M]:
 for m in [1,2,998244353,2**31-1]:
  for n in [0,1,2,M]:add(f'math 0 {x} {n} {m}',[pow(x,n,m)])
 for m in [1,2,2**31-1,M-1,M]:
  if math.gcd(x,m)==1:add(f'math 1 {x} {m}',[pow(x,-1,m)])
for n in [0,1,2,2**31,2**32-1]:
 for m in [1,2,2**32-1]:
  for a,b in [(L,L),(M,M),(-1,-1),(L,M),(M,L),(0,M),(0,L)]:
   z=floor(n,m,a,b);z=(z+2**63)%2**64-2**63
   add(f'math 2 {n} {m} {a} {b}',[z])
for m in [1,2,M]:
 for r in [L,-1,0,M]:add(f'math 3 1 {r} {m}',[r%m,m])
for cap in [0,1,M//2,M-1,M]:
 for limit in [0,1,M]:
  add(f'flow 2 1 {limit} 0 1 {cap}',[min(cap,limit),cap-min(cap,limit)])
for cost in [0,1,2,M//4-1]:
 for cap in [0,1,2, M if cost==0 else M//max(1,cost)]:
  for limit in [0,1,cap]:
   f=min(cap,limit);add(f'cost 2 1 {limit} 0 1 {cap} {cost}',[0,0]+([f,f*cost] if f else []))
bins={'cpp-debug':root/'cpp-debug','cpp-release':root/'cpp-release','swift-debug':root/'swift/.build/debug/Compare','swift-release':root/'swift/.build/release/Compare'}
rows=[]
for s,e in cases:
 for name,exe in bins.items():
  try:
   p=subprocess.run([str(exe)],input=s+'\n',text=True,capture_output=True,timeout=5)
   row=dict(input=s,expected=e,build=name,exit=p.returncode,stdout=p.stdout,stderr=p.stderr,ok=p.returncode==0 and p.stdout.strip()==e)
  except subprocess.TimeoutExpired:row=dict(input=s,expected=e,build=name,exit='timeout',ok=False)
  rows.append(row)
(root/'extended-boundary-results.json').write_text(json.dumps(rows,indent=2))
print('cases',len(cases),'runs',len(rows))
for name in bins:
 bad=[r for r in rows if r['build']==name and not r['ok']];print(name,'failures',len(bad))
 for r in bad[:6]:print(r['input'],r['exit'],repr(r.get('stdout','')),r['expected'])
