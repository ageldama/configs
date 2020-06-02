#!/usr/bin/env python3
import shlex
import json
import sys


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
                print(parsed)
                sys.exit(0)

    sys.exit(1)  # Not found.

        
