import pathlib,subprocess,json,math,random
root=pathlib.Path(__file__).resolve().parent
M=2**63-1;L=-2**63;cases=[]
def add(s,e):cases.append((s,' '.join(map(str,e))))
def crt(rs,ms):
 r=0;m=1
 for b,n in zip(rs,ms):
  g=math.gcd(m,n)
  if (b-r)%g:return [0,0]
  k=((b-r)//g*pow(m//g,-1,n//g))%(n//g) if n//g>1 else 0
  r+=m*k;m*=n//g;r%=m
 return [r,m]
mods=[[1,M],[M,M],[2,M//2],[2147483647,4294967291],[3037000499,3037000501],[6,10,15],[1,1],[]]
for ms in mods:
 if math.lcm(*ms)>M:continue
 for x in [L,L+1,-1,0,1,M-1,M]:
  for rs in [[x]*len(ms),[x+i for i in range(len(ms))] if x<M-2 else [x-i for i in range(len(ms))]]:
   add('math 3 '+' '.join(map(str,[len(ms),*rs,*ms])),crt(rs,ms))
for n in [1,2,60,61,64]:
 for x in [L,L+1,-1,0,1,M-1,M]:
  for sign in [1,-1]:
   if x==L and sign==-1:continue
   a=[0]*n;a[n//2]=x;b=[0]*n;b[0]=sign
   e=[0]*(2*n-1);e[n//2]=x*sign
   add('convll '+' '.join(map(str,[n,n,*a,*b])),e)
rng=random.Random(2026103003)
for _ in range(200):
 ms=[rng.randrange(1,3037000500),rng.randrange(1,3037000500)]
 rs=[rng.randrange(L,M+1),rng.randrange(L,M+1)]
 add('math 3 '+' '.join(map(str,[2,*rs,*ms])),crt(rs,ms))
for n in [2,60,61,64]:
 for x in [M//n, -(M//n),M//2,-(M//2)]:
  a=[x]*n;b=[1 if i%2==0 else -1 for i in range(n)]
  e=[sum(a[i]*b[k-i] for i in range(n) if 0<=k-i<n) for k in range(2*n-1)]
  assert all(L<=v<=M for v in e)
  add('convll '+' '.join(map(str,[n,n,*a,*b])),e)
bins={'cpp-debug':root/'cpp-debug','cpp-release':root/'cpp-release','swift-debug':root/'swift/.build/debug/Compare','swift-release':root/'swift/.build/release/Compare'}
rows=[]
for s,e in cases:
 for name,exe in bins.items():
  try:
   p=subprocess.run([str(exe)],input=s+'\n',text=True,capture_output=True,timeout=8)
   rows.append(dict(input=s,expected=e,build=name,exit=p.returncode,stdout=p.stdout,ok=p.returncode==0 and p.stdout.strip()==e))
  except subprocess.TimeoutExpired:rows.append(dict(input=s,expected=e,build=name,exit='timeout',ok=False))
(root/'crt-convolution-boundary-results.json').write_text(json.dumps(rows,indent=2)+'\n')
print('cases',len(cases),'runs',len(rows))
for name in bins:
 bad=[r for r in rows if r['build']==name and not r['ok']];print(name,len(bad))
 for r in bad[:4]:print(r['input'][:150],r['exit'],r.get('stdout','')[:100])
