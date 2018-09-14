import unittest
from tkinter import *
from tkinter import messagebox
from tkinter import filedialog


class Application():

    def __init__(self, title='jekyll Help'):
        self.root = Tk()
        self.root.title(title)
        self.__init_draw()
        self.__geometry()
        self.is_show = False
        pass

    def __geometry(self, width=300, height=350):
        screenwidth = self.root.winfo_screenwidth()
        screenheight = self.root.winfo_screenheight()
        size = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
        self.root.geometry(size)
        pass

    def show(self):
        self.is_show = True
        self.root.mainloop()
        pass

    def __create_yaml(self, frame, name, row):
        Label(frame, text=name).grid(row=row, column=1, padx=10, pady=5)
        e = Entry(frame)
        e.grid(row=row, column=2, padx=10, pady=5)
        return e

    def __create_ck_btn(self, frame, txt):
        c = Checkbutton(frame, text=txt)
        c.select()
        c.pack(side=LEFT)
        return c

    def __create_btn(self, frame, txt):
        btn = Button(frame, text=txt, width=8)
        btn.pack(side=LEFT, padx=2)
        return btn

    def __init_draw(self):
        # 创建标签组
        yaml_group = LabelFrame(self.root, text='Yaml', padx=5, pady=5)
        yaml_group.pack(padx=10, pady=10, side=TOP, fill=BOTH, expand=YES)
        self.yaml_date = self.__create_yaml(yaml_group, 'date', 0)
        self.yaml_title = self.__create_yaml(yaml_group, 'title', 1)
        self.yaml_categories = self.__create_yaml(yaml_group, 'categories', 2)
        self.yaml_tags = self.__create_yaml(yaml_group, 'tags', 3)
        self.yaml_filename = self.__create_yaml(yaml_group, 'filename', 4)

        # 创建复选框组
        ck_btn_group = LabelFrame(self.root, padx=5, pady=5)
        ck_btn_group.pack(padx=10, pady=3, after=yaml_group)
        self.ck_add_toc = self.__create_ck_btn(ck_btn_group, '添加目录')
        self.ck_add_summary = self.__create_ck_btn(ck_btn_group, '添加摘要')

        # 创建按钮组
        btn_group = LabelFrame(self.root, padx=5, pady=5)
        btn_group.pack(padx=10, pady=10, side=BOTTOM)
        self.btn_ok = self.__create_btn(btn_group, '确定')
        self.btn_preview = self.__create_btn(btn_group, '预览')
        self.btn_cancel = self.__create_btn(btn_group, '取消')

    def __check_visibility(self):
        if not self.is_show:
            self.root.withdraw()

    def __clear_visibility(self):
        if not self.is_show:
            self.root.deiconify()

    def showerror(self, title=None, message=None):
        self.__check_visibility()
        messagebox.showerror(title, message)
        self.__clear_visibility()

    def askopenfilename(self, title):
        self.__check_visibility()
        file = filedialog.askopenfilename(title=title)
        self.__clear_visibility()
        return file


def printmsg(app):
    def fuc():
        app.showerror('错误', '生成目录不存在')

    return fuc


class MyTestCase(unittest.TestCase):
    def test_show_common_windows(self):
        app = Application()
        app.show()

    def test_show_messagebox(self):
        app = Application()
        app.showerror('错误', '生成目录不存在')

    def test_show_file_choose(self):
        app = Application()
        file = app.askopenfilename(title='选择一个markdown文件')
        print('file is ', file)
        self.assertIsNotNone(file)

    def test(self):
        app = Application()
        app.btn_ok.bind("<Button-1>",lambda event:app.showerror('1','2'))
        app.show()


if __name__ == '__main__':
    unittest.main()
