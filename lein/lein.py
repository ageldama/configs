#!/usr/bin/env python

import sys
from glob import glob
from os import makedirs, system, getenv
from os.path import expanduser, dirname, exists
from urllib import urlretrieve


### inits

VERSION = "1.0.0"

if sys.platform == "win32":
    CP_SEP = ";"
else:
    CP_SEP = ":"


LEIN_JAR = expanduser("~/.m2/repository/leiningen/leiningen/%s/leiningen-%s-standalone.jar" % (VERSION, VERSION))

CLOJURE_JAR = expanduser("~/.m2/repository/org/clojure/clojure/1.1.0-alpha-SNAPSHOT/clojure-1.1.0-alpha-SNAPSHOT.jar")

CPS = glob("lib/*")
  
LEIN_URL = "http://repo.technomancy.us/leiningen-%s-standalone.jar" % (VERSION)


# leiningen installation checks

LEIN_BIN_DIR = dirname(sys.argv[0])

if exists(LEIN_BIN_DIR + "../src/leiningen/core.clj"):
    # running from source-checkout
    LEIN_LIBS = glob(LEIN_BIN_DIR + "/*")
    CLASSPATH = CP_SEP.join(CPS + [LEIN_LIBS])
    if len(LEIN_LIBS) < 1 and sys.argv[1] != 'self-install':
        print "Your Leiningen development checkout is missing its dependencies."
        print "Please download a stable version of Leiningen to fetch the deps."
        print "See the \"Hacking\" section of the readme for details."
        exit(1)
else:
    # not running from a checkout
    CLASSPATH = CP_SEP.join(CPS + [LEIN_JAR])
    if not exists(LEIN_JAR) and sys.argv[1] != 'self-install':
        print "Leiningen is not installed. Please run \"lein self-install\"."
        exit(1)

if getenv("DEBUG"):
    print CLASSPATH

### defs

def download_lein_jar():
    # TODO: wget / curl?
    print("downloading %s -> %s ..." % (LEIN_URL, LEIN_JAR)),
    sys.stdout.flush()
    LEIN_JAR_DIR = dirname(LEIN_JAR)
    if not exists(LEIN_JAR_DIR):
        makedirs(LEIN_JAR_DIR)
    # 'urlretrieve' is incrediblly slow! but it is portable anyway...
    urlretrieve(LEIN_URL, LEIN_JAR)
    print("done")

def start_repl(argv):
    # TODO: rlwrap?
    CMD = "java -cp 'src:classes:%s' clojure.main %s" % (CLASSPATH, " ".join(argv))
    system(CMD)

def run_leiningen(argv):
    def escape_arg(s):
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
    #
    ARGS = " ".join([ '"' + escape_arg(s) + '"' for s in argv ])
    CMD = "java -Xbootclasspath/a:'%s' -client -cp '%s' clojure.main -e \"(use 'leiningen.core)(-main %s)\"" % (CLOJURE_JAR, CLASSPATH, ARGS)
    system(CMD)


### main

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'self-install':
        download_lein_jar()
    elif len(sys.argv) > 1 and sys.argv[1] == 'repl':
        start_repl(sys.argv[2:])
    else:
        run_leiningen(sys.argv[1:])

### EOF
