#!/usr/bin/env python
from tkinter import Tk
root = Tk()
root.withdraw()

from tkinter.simpledialog import askstring
answer = askstring("???", "> ")
print(answer)

from pathlib import Path
from datetime import datetime

if answer is not None:
    with Path('~/.monologue.txt').expanduser().open('a') as f:
        f.write(str(datetime.now()) + ' : ' + answer + '\n')

