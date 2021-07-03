#!/usr/bin/env python
import zipfile
import os
import sys



def unzip(source_file, dest_path):
  with zipfile.ZipFile(source_file, 'r') as zf:
    zipInfo = zf.infolist()
    for member in zipInfo:
      member.filename = member.filename.decode("euc-kr").encode("utf-8")
      zf.extract(member)

if __name__ == "__main__":
  unzip(sys.argv[1], '')
