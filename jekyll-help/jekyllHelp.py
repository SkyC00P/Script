# -*- coding: UTF-8 -*-
from tkinter import *
from tkinter import messagebox
from tkinter import filedialog
from time import strptime
import datetime
from sys import argv
import os, shutil
import chardet

widget_entrys = {}
yaml_tag = ('date', 'title', 'categories', 'tags', 'filename')
yamls = {}
is_add_toc = True
is_auto_add_excerpt = True
has_toc = False
has_add_excerpt = False
has_yamls = False  # 文件是否存在yaml头信息
path_to = 'D:\\project\\skyc00p.github.io\\_posts'


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

    row = 0
    for yaml, txt in yamls.items():
        Label(yamlGroup, text=yaml).grid(row=row, column=1, padx=10, pady=5)
        e = Entry(yamlGroup)
        e.grid(row=row, column=2, padx=10, pady=5)
        e.insert(0, txt)
        widget_entrys[yaml] = e
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
        ('确定', gui_btn_ok), ('预览', gui_btn_preview), ('取消', lambda: root.quit()),
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
    # 截取前300个字符为摘要。
    for tag in yaml_tag:
        txt = widget_entrys[tag].get()
        yamls[tag] = txt

    date = yamls.setdefault('date', '')
    try:
        strptime(date, '%Y-%m-%d')
    except:
        messagebox.showerror('错误', 'date 格式不符合 yyyy-MM-dd')
        return

    # 写入yaml到新文件
    newfile = path_to + "\\" + yamls['date'] + '-' + yamls['filename'] + '.md'
    with open(file, 'rb') as f:
        lines = f.readlines()

    fd_buf = open(newfile, 'w', encoding='utf-8')

    if not has_yamls:
        fd_buf.write('---\n')
        fd_buf.write('layout: post\n')
        fd_buf.write('author: skycoop\n')
        yamls.pop('filename')
        for k, v in yamls.items():
            txt = k + ': ' + v + '\n'
            fd_buf.write(txt)
        fd_buf.write('---\n')
        fd_buf.flush()
    else:
        # todo 如果源文件已经存在头文件，更新他
        pass

    if not has_toc and is_add_toc:
        fd_buf.write('\n* content\n{:toc}\n\n')
        fd_buf.flush()

    if not has_add_excerpt and is_auto_add_excerpt:
        if lines.count(b'\r\n') != 0:
            index = lines.index(b'\r\n')
            lines.insert(lines.index(b'\r\n', index + 1) + 1, b'<!--more-->\n')
        elif lines.count(b'\n') != 0:
            index = lines.index(b'\n')
            lines.insert(lines.index(b'\n', index + 1) + 1, b'<!--more-->\n')
        else:
            lines.insert(12, b'<!--more-->\n')

    for line in lines:
        fd_buf.write(str(line.strip(), encoding='utf-8'))
        fd_buf.write('\n')

    fd_buf.close()
    if messagebox.askyesno('Jekyll-Help', '是否打开生成目录查看文件'):
        os.startfile(path_to)

    exit()
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


# 获取系统传来的参数
def get_sys_args():
    if len(argv) == 2 and argv[1]:
        return argv[1]
    else:
        return ''


# 判断是否为空，参数是否为文件路径，文件是否存在，后缀名是否为md
def check_args(file):
    if not file:
        return False

    return os.path.isfile(file) and os.path.splitext(file)[1] == '.md' \
           and os.access(file, os.R_OK) and os.access(file, os.W_OK)


def ask_user():
    root = Tk()
    root.withdraw()
    messagebox.showerror('错误', '必须选择一个markdown文件')
    file = filedialog.askopenfilename(title='选择一个markdown文件')
    root.destroy()
    return file


# 1. 获得文件的名字
# 2. 初始化yamls的值
# 3. 搜索是否存在目录标签和摘要标签
def read_file(file):
    global yamls
    filename = os.path.splitext(os.path.basename(file))[0]

    fd_file = open(file, 'rb')
    line = fd_file.readline()
    count = 1
    if line.startswith(b'---'):
        line = fd_file.readline()
        count += 1
        while count != 200 and not line.startswith(b'---'):
            encoding = chardet.detect(line)['encoding']
            yaml = line.decode(encoding).strip().split(':', 1)
            if yaml[0] in yaml_tag:
                yamls[yaml[0]] = yaml[1]
            line = fd_file.readline()
            count += 1

        if line.startswith(b'---'):
            global has_yamls
            has_yamls = True
        else:  # 没找到Yaml的结束符，关闭重新打开文件，类似定位到文件头
            fd_file.close()
            fd_file = open(file, 'rb')

    # 在剩余的200行内寻找目录标签和摘要标签
    isFind = 0
    count = 0
    while line:
        if line.strip() == b'* content':
            nextLine = fd_file.readline()
            count += 1
            if nextLine.strip() == b'{:toc}':
                global has_toc
                has_toc = True
                isFind += 1
        elif line.strip() == b'<!--more-->':
            global has_add_excerpt
            has_add_excerpt = True
            isFind += 1

        count += 1
        if count == 200 or isFind == 2:
            break
        line = fd_file.readline()

    fd_file.close()
    yamls.setdefault('date', datetime.datetime.now().strftime('%Y-%m-%d'))
    yamls.setdefault('title', filename)
    yamls.setdefault('categories', '技术总结')
    yamls.setdefault('tags', '')
    yamls.setdefault('filename', filename)


if __name__ == '__main__':
    # 获取命令行传来的参数
    file = get_sys_args()

    # 检验命令行参数是否合乎规范，是否传来一个 md 文件的路径，文件是否存在
    # 否则与用户进行交互，让用户提供一个路径
    while not check_args(file):
        file = ask_user()

        if not file:
            exit()

    if not os.path.isdir(path_to):
        root = Tk()
        root.withdraw()
        messagebox.showerror('错误', '生成目录不存在')
        exit()

    read_file(file)

    # 显示操作窗口
    show_gui()
