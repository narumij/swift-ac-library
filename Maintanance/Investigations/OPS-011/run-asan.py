import pathlib,json,subprocess,collections
p=pathlib.Path(__file__).resolve().parent.parent/'OPS-010'
cases=json.loads((p/'results/corpus.json').read_text())['cases']
items=[(c['input'],' '.join(map(str,c['expected'])))for c in cases]
for file in ['extended-boundary-results.json','crt-convolution-boundary-results.json']:
 items += [(c['input'],c['expected'])for c in json.loads((p/file).read_text())if c['build']=='cpp-debug']
items += [(c['input'],c['expected'])for c in json.loads((p/'structural-boundary-results.json').read_text())['cases']]
groups=collections.defaultdict(list)
for s,e in items:groups[s.split()[0]].append((s,e))
results=[]
for mode,cases in groups.items():
 r=subprocess.run([str(p/'swift/.build/release/Compare')],input='\n'.join(s for s,e in cases)+'\n',text=True,capture_output=True,timeout=120)
 pathlib.Path('/tmp/acl-sanitizers/asan-'+mode+'.stderr').write_text(r.stderr)
 ok=r.returncode==0 and r.stdout.splitlines()==[e for s,e in cases] and 'ERROR: AddressSanitizer'not in r.stderr
 results.append(dict(mode=mode,cases=len(cases),exit=r.returncode,ok=ok))
 print(mode,len(cases),ok,flush=True)
pathlib.Path('/tmp/acl-sanitizers/asan-results.json').write_text(json.dumps(results,indent=2))
