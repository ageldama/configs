#!/usr/bin/env python

import sys
import subprocess
import shlex

if __name__ == '__main__':
    title = sys.argv[1] if len(sys.argv) > 1 else 'really???'

    cmd = f"rofi -theme-str 'window {{width: 200px; height: 150px;}}' -dmenu -p '{title}' -sep '\\0' -eh 2 -markup-rows -format i"
    # cmd = shlex.split(cmd)
    # print(cmd)
    with subprocess.Popen(cmd, stdin=subprocess.PIPE, shell=True) as p:
        p.stdin.write(b"<span size='x-large' weight='heavy'>Yes</span>\0")
        p.stdin.write(b"<span size='x-large' weight='heavy'>No</span>\0")
        p.stdin.flush()
        exitcode = p.wait()
        # print('EXIT:', exitcode)

