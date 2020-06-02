#!/usr/bin/env python3
import shlex
import json
import sys


def rmsbolty_compile_command(cmd):
    parsed = shlex.split(cmd)
    skip = False
    coll = []
    for part in shlex.split(cmd):
        if part == '-c' or part == '-o':
            skip = True
        else:
            if skip:
                skip = False
            else:
                coll.append(part)
    return shlex.join(coll)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.exit(1)

    comp_cmds_json_fn = sys.argv[1]
    d_src_fn = sys.argv[2]

    rmsbolty = False
    if len(sys.argv) >= 4 and sys.argv[3] == '--no-c-and-o':
        rmsbolty = True
    # print(rmsbolty)

    with open(comp_cmds_json_fn, 'r') as in_f:
        j = json.load(in_f)

        for i in j:
            if i['file'] == d_src_fn:
                cmd = i['command']
                if rmsbolty:
                    print(rmsbolty_compile_command(cmd))
                else:
                    print(cmd)    
                sys.exit(0)

        # Not found: build a list of candidates
        if rmsbolty:
            cmds = set()

            for i in j:
                cmds.add(rmsbolty_compile_command(i['command']))

            for cmd in cmds:
                print(cmd)

            sys.exit(0)
