#!/usr/bin/env python3

import json
import argparse
from collections import Counter
import subprocess
import os
import os.path
import re
import sys
import shlex


class CompileCommands(object):
    cc_commands = Counter()
    inc_dirs = set()

    def __init__(self):
        pass

    def get_inc_dirs(self, curr_dir=True, escape=True):
        esc = shlex.quote
        if not escape:
            esc = lambda s: s

        dirs = []
        dirs.extend(self.inc_dirs)
        if curr_dir:
            dirs.append('.')
            
        return [ shlex.quote(os.path.abspath(d)) for d in dirs ]
        
    def load(
            self,
            filename='compile_commands.json',
            load_system_incdir=False,
    ):
        # compile_commands.json :
        with open(filename, 'r') as f:
            parsed = json.load(f)

            for row in parsed:
                directory = row['directory'] or '.'

                if 'command' in row:
                    cmd = row['command'].split()[0]
                    self.cc_commands.update([cmd])

                    for cmd_part in shlex.split(row['command']):
                        if cmd_part[0:2] == '-I':
                            self.inc_dirs.add(cmd_part[2:])

                if 'arguments' in row:
                    self.cc_commands.update([row['arguments'][0]])

                    inc_dir_next = False
                    for arg in row['arguments']:
                        if inc_dir_next:
                            # ...지난 번 열이 `-I`였을 때: 그냥 추가.
                            self.inc_dirs.add(arg)
                            inc_dir_next = False
                        elif arg == '-I':
                            # 그냥 `-I` ==> 다음 열이 incdir.
                            inc_dir_next = True
                        elif arg.startswith('-I') and len(arg) > 3:
                            # `-I${dir}`의 형태:
                            self.inc_dirs.add(arg[2:])

        #
        if load_system_incdir:
            self.load_system_incdir()

        # bye: ok
        return self


    def load_system_incdir(self):
        cc = self.cc_commands.most_common()[0][0]

        # find inc-dirs from `gcc` | `g++` | `clang++` ...:
        lang = 'c'
        if '++' in cc:
            lang = 'c++'
            
        cmd = f"echo | {cc} -v -x {lang} -E -"
        output = subprocess.check_output(cmd, shell=True, encoding='utf-8',     stderr=subprocess.STDOUT)

        pat_start = re.compile(r"\#include .+ search starts here\:")
        pat_end = re.compile(r"End of search list.")

        dirs = set()

        next_dir_listing = False
        for line in output.split(os.linesep):
            if pat_start.match(line):
                next_dir_listing = True
            elif pat_end.match(line):
                next_dir_listing = False
            elif next_dir_listing:
                dirs.add(line.strip())

        # print(dirs)
        self.inc_dirs.update(dirs)

    def __repr__(self):
        return f"<CompileCommands: cc_commands={self.cc_commands} inc_dirs={self.inc_dirs}>"


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        prog='compile_commands_json.py',
        description='What the program does',
        epilog='')

    parser.add_argument('-i', '--includes',
                        help='parse `-I`-options (default: YES)',
                        default=True,
                        action='store_true') 

    parser.add_argument('-y', '--system',
                        help='system-include-dirs as well',
                        action='store_true') 

    parser.add_argument('--ctags',
                        help='build ctags',
                        action='store_true') 

    parser.add_argument('--ctags-etags',
                        help='build etags by using ctags',
                        action='store_true') 

    parser.add_argument('--etags',
                        help='build etags',
                        action='store_true') 

    parser.add_argument('-p', '--print',
                        help='print include-dirs',
                        action='store_true') 

    args = parser.parse_args()
    # print(args)

    compcmds = CompileCommands()
    compcmds.load(load_system_incdir=args.system)
    print(compcmds, file=sys.stderr)

    if args.ctags:
        cmd = 'ctags -R '
        cmd = cmd + ' '.join(compcmds.get_inc_dirs())
        print(cmd, file=sys.stderr)
        subprocess.run(cmd, shell=True)
    if args.ctags_etags:
        cmd = 'ctags -Re '
        cmd = cmd + ' '.join(compcmds.get_inc_dirs())
        print(cmd, file=sys.stderr)
        subprocess.run(cmd, shell=True)
    if args.etags:
        cmd = 'etags -R '
        cmd = cmd + ' '.join(compcmds.get_inc_dirs())
        print(cmd, file=sys.stderr)
        subprocess.run(cmd, shell=True)
    if args.print:
        for inc_dir in compcmds.get_inc_dirs(escape=False):
            print(inc_dir)
        
