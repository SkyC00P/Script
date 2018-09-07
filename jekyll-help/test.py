file=r'D:\document\MD文档\python\初识Python.md'
newfile='d:\\1.md'

with open(file, 'rb') as f:
    lines = f.readlines()

fd_buf = open(newfile,'w',encoding='utf-8')
fd_buf.write('---\n')
fd_buf.write('layout:post\n')
fd_buf.write('author:skycoop\n')
fd_buf.write('---\n')

fd_buf.write('\n* content\n{:toc}\n\n')

if lines.count(b'\r\n') != 0 :
    index = lines.index(b'\r\n')
    lines.insert(lines.index(b'\r\n',index+1) + 1, b'<!--more-->\n')
elif lines.count(b'\n') != 0 :
    index = lines.index(b'\n')
    lines.insert(lines.index(b'\n', index + 1) + 1, b'<!--more-->\n')

for line in lines:
    strw = str(line.strip(),encoding='utf-8')
    fd_buf.write(strw)
    fd_buf.write('\n')

fd_buf.flush()
fd_buf.close()