import json

result = {}
txt = ""

with open('data.json') as f:
    data = f.readlines()
    for element in data:
        obj = json.loads(element)
        id = int(obj["_id"])
        result[id] = obj["_source"]["quote"]
    for i in sorted(result.keys()):
        print i
        txt = txt + result[i] + "\n\n"
    with open('mt.txt', 'w') as w:
        w.write(txt.encode('utf-8'))
    w.close()
f.close()

