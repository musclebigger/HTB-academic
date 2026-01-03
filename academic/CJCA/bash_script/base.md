# Special Variables特殊变量
Internal Field Separator (IFS) to 来鉴别特殊变量
- "$#": 这个变量保存传递给脚本的参数数量。
- "$@": 这个变量可用于获取命令行参数列表。
- "$n": 可以通过参数的位置有选择地获取每个命令行参数。例如，第一个参数是 $1。
- "$$": 当前正在执行的进程的进程ID。
- "$?": 脚本的退出状态。这个变量用于判断命令是否成功执行。值为 0 表示成功执行，而 1 表示执行失败。

bash之间的空格是严格的，比如：
variable = "this will result with an error."
就不对variable="Declared without an error."才可以

# 字符串运算符
- “==“	is equal to
- “!=”	is not equal to
- “<”	is less than in ASCII alphabetical order
- “>”	is greater than in ASCII alphabetical order
- “-z”	if the string is empty (null)
- ”-n“	if the string is not null

# 数字运算符
- -eq	is equal to
- -ne	is not equal to
- -lt	is less than
- -le	is less than or equal to
- -gt	is greater than
- -ge	is greater than or equal to

# File Operators文件操作符
- -e	if the file exist
- -f	tests if it is a file
- -d	tests if it is a directory
- -L	tests if it is if a symbolic link
- -N	checks if the file was modified after it was last read
- -O	if the current user owns the file
- -G	if the file’s group id matches the current user’s
- -s	tests if the file has a size greater than 0
- -r	tests if the file has read permission
- -w	tests if the file has write permission
- -x	tests if the file has execute permission

# 特殊的循环
- while：条件为真就继续
- until：条件为假才继续（直到条件为真才停）

# function的回复值
function创建可以不加function，$?状态码

| Exit code | 含义                             | 直白解释                                    |
| --------- | ------------------------------ | --------------------------------------- |
| 2         | General errors                 | 一般错误，命令参数有问题、逻辑失败                       |
| 2         | Misuse of shell builtins       | Shell 内建命令用错了，例如 `cd` 没带参数              |
| 126       | Command invoked cannot execute | 找到了命令，但权限不足或者不可执行                       |
| 127       | Command not found              | 根本找不到命令                                 |
| 128       | Invalid argument to exit       | 你在脚本里写 `exit X`，X 不合法                   |
| 128+n     | Fatal error signal "n"         | 进程收到 **信号 n** 被杀死，例如 128+9 = KILL 信号    |
| 130       | Script terminated by Control-C | 进程被 Ctrl+C 中断（SIGINT = 2 → 128+2 = 130） |
| 255*      | Exit status out of range       | exit 返回码太大，超过 0-255 范围（Bash 截取成 0-255）  |


# debug 

使用bash的参数bash -x就可以debug,-v就能显示展示