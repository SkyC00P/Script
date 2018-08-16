from tkinter import *

root = Tk()
e=Entry(root, name='ee')

e.pack()
Button(root,text='111', command=lambda : print(e.config)).pack()
root.mainloop()