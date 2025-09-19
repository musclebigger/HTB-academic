# Find Files and Directories
# 最快用这个
locate *.conf
# 搜文件链接
which python
# find
# -type f 文件类型
# -name *.conf 文件名
# -user root 拥有者
# -size +20k 文件大小
# -newermt 2020-03-03 指定文件最晚创建日期
# -exec ls -al {} \;展开内容
# 2>/dev/null 不显示错误
find / -type f -name *.conf -user root -size +20k -size -28k -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
# 计数
find / -name "*.bak" 2>/dev/null | wc -l
