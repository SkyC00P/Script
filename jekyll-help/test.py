from tkinter import *

yamls = {}
yamls['date']=1
date = yamls.setdefault('date', '')

if not date:
    print("not date ", date)
else:
    print("has date ", date)

yaml_tag = ('date', 'title', 'categories', 'tags', '文件名')

index = 1
for tag in yaml_tag:
    yamls[tag] = ""

print("dict is ", yamls)

for a, b in yamls.items():
    print(a, " + ", b)
