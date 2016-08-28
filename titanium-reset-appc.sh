#!/usr/bin/python
import uuid
import sys

path = sys.argv[1]

new = []
with open(path) as f:
    data = f.readlines()

    for line in data:
        if line.strip().startswith('<property name="appc-'):
            continue
        if line.strip().startswith('<property name="acs-'):
            continue
        if line.strip().startswith('<guid>'):
            line = '    <guid>%s</guid>\n' % (str(uuid.uuid1()))

        new.append(line)

with open(path, 'w') as f:
    f.writelines(new)
