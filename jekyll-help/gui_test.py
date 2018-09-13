import unittest
from tkinter import *
from tkinter import messagebox
from tkinter import filedialog


class Application():
    pass


class MsgBox():
    pass


class MyTestCase(unittest.TestCase):
    def test_show_common_windows(self):
        root = Tk()
        root.mainloop()

    def test_show_messagebox(self):
        root = Tk()
        root.withdraw()
        msg = messagebox.showinfo('Info', 'The Info Msg...')
        print('show info msg:', msg)

        msg = messagebox.showerror('Error', 'The Error Msg...')
        print('show err msg:', msg)

    def test_show_file_choose(self):
        root = Tk()
        root.withdraw()
        file = filedialog.askopenfilename(title='选择一个markdown文件')
        print('file is ', file)
        self.assertIsNotNone(file)

    # 窗口标题为jekyll Help，窗口指定大小300,500，居中显示
    def test_main_windows(self):
        root = Tk()
        root.title('jekyll Help')
        screenwidth = root.winfo_screenwidth()
        screenheight = root.winfo_screenheight()
        width = 300
        height = 350
        size = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
        root.geometry(size)
        root.mainloop()
        pass

    def test_draw_all(self):
        root = Tk()

        # 创建标签组
        yamlGroup = LabelFrame(root, text='Yaml', padx=5, pady=5)
        yamlGroup.pack(padx=10, pady=10, side=TOP, fill=BOTH, expand=YES)
        row = 0
        for yaml in {'date': '', 'title': '', 'categories': '', 'tags': '', 'filename': ''}:
            Label(yamlGroup, text=yaml).grid(row=row, column=1, padx=10, pady=5)
            e = Entry(yamlGroup)
            e.grid(row=row, column=2, padx=10, pady=5)
            row += 1

        # 创建复选框组
        ckBtnGroup = LabelFrame(root, padx=5, pady=5)
        ckBtnGroup.pack(padx=10, pady=3, after=yamlGroup)
        for cktext in ['添加目录', '添加摘要']:
            c = Checkbutton(ckBtnGroup, text=cktext)
            c.select()
            c.pack(side=LEFT)

        # 创建按钮组
        btnGroup = LabelFrame(root, padx=5, pady=5)
        btnGroup.pack(padx=10, pady=10, side=BOTTOM)
        for w_btn in ['确定', '预览', '取消']:
            Button(btnGroup, text=w_btn, width=8).pack(side=LEFT, padx=2)

        root.mainloop()
        pass


if __name__ == '__main__':
    unittest.main()
