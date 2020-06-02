#!/usr/bin/env python3
import shlex
import json
import sys


def extract_incdir(s):
    if s.startswith('-I'):
        return s[2:]
    return None

    
if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.exit(1)

    comp_cmds_json_fn = sys.argv[1]
    d_src_fn = sys.argv[2]

    with open(comp_cmds_json_fn, 'r') as in_f:
        j = json.load(in_f)

        for i in j:
            if i['file'] == d_src_fn:
                cmd = i['command']
                parsed = shlex.split(cmd)

                coll = []
                
                for part in parsed:
                    incdir = extract_incdir(part)
                    if incdir is not None:
                        coll.append(incdir)

                for incdir in coll:
                    print(incdir)

                sys.exit(0)

        # Not found: sum all
        incdirs = set()

        for i in j:
            cmd = i['command']
            parsed = shlex.split(cmd)
                
            for part in parsed:
                incdir = extract_incdir(part)
                if incdir is not None:
                    incdirs.add(incdir)

        for incdir in incdirs:
            print(incdir)

        
