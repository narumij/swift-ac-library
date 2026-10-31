import json, sys

d = sys.argv[1]

def load(name):
    out = {}
    for task in json.load(open(f"{d}/{name}.json"))["tasks"]:
        lang = task["title"].split()[0]
        for size, samples in task["results"].items():
            ns = [s[1] / 1e9 / int(size) for s in samples]
            out[(lang, int(size))] = (sum(ns) / len(ns), len(ns))
    return out

b, a = load("before"), load("after")
print("| Lang | Size | before ns/input | after ns/input | change | n |")
print("| --- | ---: | ---: | ---: | ---: | ---: |")
for key in sorted(b, key=lambda k: (k[0], k[1])):
    if key not in a:
        continue
    (bv, bn), (av, an) = b[key], a[key]
    print(f"| {key[0]} | {key[1]} | {bv:.2f} | {av:.2f} | {(av / bv - 1) * 100:+.1f}% | {bn}/{an} |")
