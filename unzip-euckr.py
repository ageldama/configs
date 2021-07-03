#!/usr/bin/env python
import zipfile
import os
import sys



def unzip(source_file, dest_path):
  with zipfile.ZipFile(source_file, 'r') as zf:
    zipInfo = zf.infolist()
    for member in zipInfo:
      try:
        print(member.filename.encode('cp437').decode('euc-kr', 'ignore'))
        member.filename = member.filename.encode('cp437').decode('euc-kr', 'ignore')
        zf.extract(member, dest_path)
      except:
        print(source_file)
        raise Exception('what?!')

if __name__ == "__main__":
  unzip(sys.argv[1], '')
