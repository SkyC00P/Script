# -*- coding: UTF-8 -*-
from tkinter import *

yaml_tag = ''
new_file_name = ''
is_add_toc = True
is_auto_add_excerpt = True
path_to = ''


# 检验文件是否拥有标准的yaml头标签
def check_has_yaml(path) -> bool:
    return false


# 创建yaml头标签
def create_yaml_tag():
    pass


# 显示操作GUI
def show_gui():
    root = Tk()
    root.title("Jekyll Help")
    screenwidth = root.winfo_screenwidth()
    screenheight = root.winfo_screenheight()
    width = 300
    height = 350
    size = '%dx%d+%d+%d' % (width, height, (screenwidth - width) / 2, (screenheight - height) / 2)
    root.geometry(size)

    # 创建标签组
    yamlGroup = LabelFrame(root, text='Yaml', padx=5, pady=5)
    yamlGroup.pack(padx=10, pady=10, side=TOP, fill=BOTH, expand=YES)
    yamls = [('date', '2018-08-17'), ('title', 'test'),
             ('categories', 'cat'), ('tags', '标签'), ('文件名', '文件名'),
             ]
    row = 0
    for yaml, txt in yamls:
        Label(yamlGroup, text=yaml).grid(row=row, column=1, padx=10, pady=5)
        e = Entry(yamlGroup)
        e.grid(row=row, column=2, padx=10, pady=5)
        e.insert(0, txt)
        row += 1

    # 创建复选框组
    ckBtnGroup = LabelFrame(root, padx=5, pady=5)
    ckBtnGroup.pack(padx=10, pady=3, after=yamlGroup)
    ck_btns = [('添加目录', update_is_add_toc),
               ('添加摘要', update_is_auto_add_excerpt), ]
    for cktext, fnc in ck_btns:
        c = Checkbutton(ckBtnGroup, text=cktext, command=fnc)
        c.select()
        c.pack(side=LEFT)

    # 创建按钮组
    btnGroup = LabelFrame(root, padx=5, pady=5)
    btnGroup.pack(padx=10, pady=10, side=BOTTOM)

    btns = [
        ('确定', gui_btn_ok()), ('预览', gui_btn_preview()), ('取消', lambda: root.quit()),
    ]

    for w_btn, fuc in btns:
        Button(btnGroup, text=w_btn, width=8, command=fuc).pack(side=LEFT, padx=2)

    root.mainloop()
    pass

# 确定生成markdown文件
# 1. 合成或更新Yaml标签
# 2. 插入(保留)或删除目录标记
# 3. 插入(保留)或生成摘要标记
def gui_btn_ok():
    # 读取5个标签的值，判断时间是否规范
    # 按标准Yaml保存到新文件
    # 按需求是否生成目录标记
    # 读取源文件，跳过源文件的Yaml头，目录标记，如果有
    # 一直读取剩下的内容写入到新文件中，除非遇到摘要标记(为忽略的话)
    pass


def gui_btn_preview():
    pass


def update_is_add_toc():
    global is_add_toc
    is_add_toc = not is_add_toc


def update_is_auto_add_excerpt():
    global is_auto_add_excerpt
    is_auto_add_excerpt = not is_auto_add_excerpt


def test():
    pass


def get_sys_args():
    pass


def check_args(args):
    pass


def ask_user():
    pass


def config_not_set():
    pass


def init_config():
    pass


def read_file():
    pass


if __name__ == '__main__':
    # 获取命令行传来的参数
    args = get_sys_args()

    # 检验命令行参数是否合乎规范，是否传来一个 md 文件的路径，文件是否存在
    # 否则与用户进行交互，让用户提供一个路径
    if not check_args(args):
        ask_user()

    # 初次需要配置些参数
    if config_not_set():
        init_config()

    # 读取md文件
    read_file()

    # 显示操作窗口
    show_gui()
