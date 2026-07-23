# c-scripts-rofi

Blazingly fast and easy way to launch your scripts with [Rofi](https://github.com/davatorium/rofi)

```
$ ./scripts-rofi --help
It asks to select a script within SCRIPT_DIRS and execute it.

(NO_DB_FLAG_FILE:	/home/XXX/.no-db-c-scripts-rofi)

-p | --print : print selection (0)
-s | --save  : save selection (0)
-e | --execute : execute selection (0)
-S SCRIPT_DIRS | --script-dirs SCRIPT_DIRS (':'-separated list)
	/home/XXX/local/scripts
	/home/XXX/local/bin
	/home/XXX/.screenlayout
-D HIST_DB_FILE   :	 /home/XXX/.c-scripts-rofi.hist
-T XTERM_COMMAND  :	 x-terminal-emulator -e
-P : Dump stored DB and exit (0)
-W : Execute wrapper (like 'wine') ((null))
-A : 'Run in terminal' tag string ( <span color='#FF69B4'>[TERM]</span>)
-m : Apply markup on tag string (1)
-/ REGEX | --file-regex REGEX : filename matching regex ((null))
-i | --ignorecase 	: ignorecase (1)

Exiting.
```


## Build

* GNU gcc 11 or Clang 13 (C11)
* CMake 3.15+ and GNU Make or Ninja

```bash
cmake # -DCMAKE_BUILD_TYPE=Debug|Release
make  # => will build the executable: `scripts-rofi`
```
