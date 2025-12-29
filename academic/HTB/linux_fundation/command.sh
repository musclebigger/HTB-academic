# 基础指令
man ls #查看帮助ls的
apropos password #模糊搜索命令，只记得 大概含义password，就会返回有可能的命令
pwd #当前目录
hostname #当前系统
ps #进程查看
ss # netstat升级办，所有套接字（TCP/UDP/UNIX/RAW/ICMP）**的实时状态
lsblk #列出系统上所有（或指定）块设备
lsof #列出所有打开文件


# 进阶
ls -t /var/backups | head -n 1 查看文件最新更新时间
# 文件查找
find <location> <options>
# 文件类型 f是file，所有带有.conf的名字，owner是root，大于20kb，2020-03-03之后的，对每个找到文件执行ls -al并显示详细信息使用{}占位符替换文件路径
# 注意：分号 ; 在 shell 中有特殊含义（命令分隔符），所以要用反斜杠 \ 来转义它，防止 shell 提前解释它，确保 find 能正确接收到这个分号。
# 2>/dev/null丢弃整条管道里的所有错误，输出2 代表标准错误（stderr），/dev/null 是“黑洞设备”，写进去的数据立即消失
find / -type f -name *.conf -user root -size +20k -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
# locate依赖于linux的定时任务，磁盘扫描索引数据库，只能按文件名模糊，不能按大小、权限、时间等过滤，但快
locate *.conf
# 只能找环境变量里的，只能找命令
which python