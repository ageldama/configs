#!/usr/bin/env python
import tkinter as tk
from pathlib import Path
from datetime import datetime

root = tk.Tk()
root.title('say sth:')

ta = tk.Text(root, height=5, width=30)

def save_and_quit(*args):
    s = ta.get('1.0', tk.END).strip()
    print(s)
    with Path('~/.monologue.txt').expanduser().open('a') as f:
        f.write(str(datetime.now()) + ' : ' + s + '\n')
    root.quit()

btn = tk.Button(root, text="Save & Quit (^D)", command=save_and_quit)
btn.pack(side='bottom', anchor='s')

root.bind('<Control-d>', save_and_quit)

vsb = tk.Scrollbar(root)
vsb.pack(side=tk.RIGHT, fill=tk.Y)

ta.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

vsb.config(command=ta.yview)
ta.config(yscrollcommand=vsb.set)

ta.pack()
ta.focus_set()

tk.mainloop()
