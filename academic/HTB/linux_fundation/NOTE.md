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