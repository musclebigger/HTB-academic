# Linux Philosophy
- **Everything is a file**: All configuration files for the various services running on the Linux operating system are stored in one or more text files.
- **Small, single-purpose programs**: Linux offers many different tools that we will work with, which can be combined to work together.
- **Ability to chain programs together to perform complex tasks**: The integration and combination of different tools enable us to carry out many large and complex tasks, such as processing or filtering specific data results.
- **Avoid captive user interfaces**: Linux is designed to work mainly with the shell (or terminal), which gives the user greater control over the operating system.
- **Configuration data stored in a text file**: An example of such a file is the /etc/passwd file, which stores all users registered on the system.

# Linux Components
Linux 启动与运行全景

1️⃣ Bootloader（GRUB） 

**角色**：第一道引导程序

**动作**：定位内核 → 加载 initrd → 把控制权交给 kernel

2️⃣ OS Kernel

**角色**：硬件管家 + 资源调度器

**动作**：驱动 CPU、内存、I/O、网络；暴露 系统调用 供上层使用，参数即文件：/proc/sys/*、/sys/*

3️⃣ Daemons（systemd 服务）

**角色**：常驻后台的服务

**动作**：执行单元文件比如/usr/lib/systemd/system/*.service，以及执行关键实例，cron（定时） cups（打印） NetworkManager（网络） sshd（远程）

4️⃣ OS Shell（Bash 等）

**角色**：用户与内核互通方式

**动作**：进入交互式、脚本化、管道、重定向，作为自动化核心

5️⃣ Graphics Server（X / Wayland）

**角色**：图形化的服务器

**动作**：图形化工具服务运行，X11等

6️⃣ Window Manager / Desktop Environment

**角色**：图形化桌面回显给用户

**动作**：用图形化工具，GNOME、KDE、XFCE、MATE、Cinnamon，关键文件：~/.config/、~/.local/share/、/usr/share/applications/*.desktop

7️⃣ Utilities（用户态工具）

**角色**：完成具体任务的小程序

**动作**：启动一些工具系统类：ps, netstat, lsof, strace，以及应用类：firefox, libreoffice, gimp

# Linux Architecture

① Hardware：
看得见摸得的部分，RAM、CPU、磁盘、网卡、USB 控制器，只认电信号，需要内核给它“翻译”指令。

② Kernel（硬件管家 + 虚拟化器）
- 职责 1 驱动硬件，提供统一 系统调用接口（read/open/clone/mmap…）
- 职责 2 虚拟化资源，每个进程以为自己独占 CPU（调度器），独占内存（页表、mm_struct），独占文件描述符表（files_struct）
- 冲突隔离：段错误、野指针只杀自己，不会崩整个系统。

③ Shell（用户 ↔ 内核 的“解释器”）

解析命令 → 组装系统调用 → 让内核干活，管道、重定向、变量替换、通配符 都是 shell 的“语法糖”

④ System Utility

内置的所有工具都可用，就是 /bin、/sbin、/usr/bin 里那些二进制：
ps netstat ss lsof strace tcpdump ip iptables systemctl

# File System Hierarchy
**/**：根目录，内核+initrd所在地，也是单用户模式下唯一挂载点。

**/bin**：必要的二进制命令

**/boot**：内核启动文件，grub.cfg、vmlinuz、initrd.img等

**/dev**：工具集的调用接口文件

**/etc**：系统配置大仓库

**/home**：用户

**/lib & /lib64**：启动阶段必备共享库，删了系统起不来。

**/media & /mnt**：临时挂载点，U 盘、ISO、NFS、Windows 分区全挂这。

**/opt**：第三方软件

**/root**：最高权限用户 suid 0

**/sbin**: 只有 root 能用的管理工具

**/tmp**: 临时文件

**/usr**： 非启动必需的 bin、lib、doc、man执行文件

**/var**: 动态数据存储位置，日志、邮件、队列、Web 内容、数据库等

# File Descriptors and Redirections
file descriptor (FD)文件描述符，内核(PCB进程控制块的文件描述符表)通过描述符去找文件。三个默认的文件描述符(当打开一个文件，进程一出生就自带占用的描述符，文件描述符总计1023位，前三位0，1，2，默认打开): 
- 0  STDIN   标准输入,默认只读
- 1  STDOUT  标准输出,默认只写
- 2  STDERR  标准错误,默认只写
- 3  ...     在进程中打开新文件后，先标记最小值（linux系统里read(int rd, void *buf, size_t count)的第一个参数就是文件描述符位置）

## 文件写入
多行、大段文字、想保持格式——用 <<EOF
极短单行、不想打字——用引号直接 cat "…"

| 维度       | `cat <<EOF … EOF` (here-document) | `cat "第一行 第二行" > stream.txt` |
| -------- | --------------------------------- | ---------------------------- |
| 数据来源     | 临时**管道**（内核缓冲区）                   | 直接**字符串参数**（位于 Shell 内存）     |
| Shell 动作 | 逐行读入 → 写临时管道 → 启动 cat → 读管道 → 写文件 | 把字符串当参数 → 启动 cat → 写文件       |
| cat 行为   | 从 0 号 stdin 读管道内容                 | 把**参数**当成要写的数据，**不读 stdin**  |
| 换行/变量展开  | 支持多行、变量 `$HOME`、命令替换等             | 整行被双引号包着，只能**一行**；同样支持变量/转义  |
| 性能       | 多一次管道拷贝，稍慢                        | 直接写，少一次拷贝                    |
| 可读性      | 适合多行、大段文本                         | 适合极短单行                       |


## 单个文件处理
- tr: 按字符级别做替换或删除，不涉及字段、正则、文件
- sed: 按行扫描标准输入，把“编辑命令”当成流水线，一次性输出结果——不改原文件
- awk: 把输入切成字段，按行做计算、判断、输出，还能写变量、循环、数组，比 cut/grep 强大得多。
tr 只认识单个字符，sed 认识字符串/正则/行号；能 tr 就别 sed，不能就换 sed。

## 正则
- 圆括号 (a)
把模式 a 当成一个整体，可统一施加量词或反向引用。
例：(ab)+ 匹配 ababab…
- 方括号 [a-z]
定义字符类，只匹配括号内任一字符（此处为任意小写字母）。
例：gr[ae]y 匹配 gray 或 grey
- 花括号 {1,10}
设定量词，规定前面元素最少 1 次、最多 10 次。
例：\d{3,5} 匹配 3~5 位数字
- 竖线 |
OR 运算符，只要左侧或右侧表达式满足即可。
例：cat|dog 匹配 cat 或 dog
- 点星 .*
串接运算符：先匹配任意字符（.），再匹配任意长度（*），两者必须按顺序出现；常被视作“AND”语义。
例：hello.*world 必须出现 hello 在前、world 在后，中间可夹任意内容

## permission结构
cry0l1t3@htb[/htb]$ ls -l /etc/passwd

```
- rwx rw- r--   1 root root 1641 May  4 23:42 /etc/passwd
- --- --- ---   |  |    |    |   |__________|
|  |   |   |    |  |    |    |        |_ Date
|  |   |   |    |  |    |    |__________ File Size
|  |   |   |    |  |    |_______________ Group
|  |   |   |    |  |____________________ User
|  |   |   |    |_______________________ Number of hard links
|  |   |   |_ Permission of others (read)
|  |   |_____ Permissions of the group (read, write)
|  |_________ Permissions of the owner (read, write, execute)
|____________ File type (- = File, d = Directory, l = Link, ... )
```

## SUID 与 SGID
除了基本的用户/组权限，Linux 还允许给文件设置“特殊权限位”，Set User ID（SUID）和 Set Group ID（SGID）。让普通用户在运行某个程序时，短暂获得该文件所属用户或所属组的权限，而不是启动者自己的权限。查看权限时，如果本来该出现 x 的位置变成了 s，就说明启用了 SUID（用户位）或 SGID（组位）。

用途：管理员常用它给特定应用“开小灶”：例如 /bin/passwd 需要写 /etc/shadow，但普通用户没有写权限；给 /bin/passwd 设 SUID 后，用户运行它时暂时变成 root，就能完成密码修改，任务结束后权限回落。

## Sticky Bit（粘着位）
linux中，当它为某个目录启用时，会额外增加一条安全规则。任何人都可以往目录里放文件，也可以看别人的文件，但只能删/改自己拥有的文件。能“动手”的人只有三个：文件所有者、目录所有者、root。其中：
- 目录控制的是“对目录这个容器能做什么”
- 文件控制的是“对文件内容能做什么”
不一定是同一个账户