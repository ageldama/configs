#!/usr/bin/env python

from os import chdir, system
from tempfile import NamedTemporaryFile
from datetime import datetime


def make_exclude_dirs_file(L, encoding='utf8'):
    ntf = NamedTemporaryFile()
    ntf.file.write(L.encode(encoding))
    ntf.file.flush()
    return ntf

EXCLUDE_DIRS = """
./dev
./lost+found
./misc
./media
./cifs
./net
./mnt
./proc
./run
./sys
./tmp
./var/lib/docker
./var/lib/transmission/dn
./home/jhyun/Dropbox
./home/jhyun/Funs
"""


if __name__ == '__main__':
    tmpf = make_exclude_dirs_file(EXCLUDE_DIRS)
    fn = tmpf.name
    chdir('/')
    NOW_STR = datetime.now().strftime('%Y%m%d_%H%M')
    BACKUP_FN = "/media/NAS1-HDD/archeee-backup/BACKUP-%s.tgz" % (NOW_STR)
    print(fn)
    system("tar --exclude-ignore-recursive=%s -cvf %s ." % (fn, BACKUP_FN))


