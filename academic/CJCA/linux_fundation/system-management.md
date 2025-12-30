# 1. Package Management
Command	Description
- dpkg：dpkg 是用于安装、构建、移除和管理 Debian 软件包的底层工具。dpkg 的主要、也是更易用的前端工具是 aptitude。
- apt：apt 为软件包管理系统提供了一个高级的命令行接口，在易用性和自动化依赖处理方面优于直接使用 dpkg。
- aptitude：aptitude 是 apt 的替代方案，同样是软件包管理器的高级接口，功能更全面，也支持交互式操作。
- snap：用于安装、配置、更新和移除 snap 软件包。Snap 支持在云环境、服务器、桌面以及物联网设备上，以更安全的方式分发最新的应用程序和工具。
- gem：gem 是 RubyGems 的前端工具，RubyGems 是 Ruby 语言的标准软件包管理器。
- pip：pip 是 Python 软件包安装工具，通常用于安装 Debian 官方仓库中未提供的 Python 包。它支持从版本控制仓库安装（目前包括 Git、Mercurial 和 Bazaar），提供详细的日志输出，并在安装前先下载所有依赖，从而避免出现部分安装失败的情况。
- git：Git 是一个快速、可扩展的分布式版本控制系统，命令集非常丰富，既提供高层次的操作，也允许直接访问底层内部机制。

软件包（package） 是一种归档文件，其中包含一个或多个 “.deb” 文件。dpkg 工具用于从对应的 “.deb” 文件中安装程序。由于许多程序都存在依赖关系，APT 让程序的安装和更新变得更加简单。如果我们直接从一个独立的 “.deb” 文件安装程序，往往会遇到依赖问题，需要额外下载并安装一个或多个依赖包。APT 通过将安装某个程序所需的全部依赖一并处理，使这一过程更加高效和便捷。

每个 Linux 发行版都会使用软件仓库（software repositories），这些仓库会被频繁更新。当我们更新程序或安装新程序时，系统会向这些仓库查询所需的软件包。仓库通常被标记为 stable（稳定版）、testing（测试版） 或 unstable（不稳定版）。大多数 Linux 发行版默认使用最稳定的仓库，也就是 “main” 仓库。

可以通过查看 /etc/apt/sources.list 文件来确认当前系统使用的仓库。
在 Parrot OS 中，其仓库列表位于 /etc/apt/sources.list.d/parrot.list。

| 维度        | `dpkg -l`                      | `apt list --installed` |
| --------- | ------------------------------ | ---------------------- |
| 所属层级      | **底层包管理器（dpkg）**               | **高层前端（APT）**          |
| 数据来源      | `/var/lib/dpkg/status`（本地权威状态） | dpkg 状态 + APT 包索引      |
| 是否依赖网络    | 否                              | 否（但依赖本地 APT cache）     |
| 显示内容      | 所有 dpkg 管理的包                   | APT 认为“已安装”的包          |
| 显示版本      | 已安装版本                          | 已安装版本 + 可用版本           |
| 输出稳定性     | **非常稳定（适合脚本）**                 | 偏人类阅读                  |
| 显示状态码     | 有（ii、rc、un 等）                  | 无 dpkg 状态码             |
| 是否包含残留配置包 | 会显示 `rc`                       | **通常不显示**              |
| 是否过滤损坏状态  | 不过滤                            | 可能被隐藏                  |


# 2. 进程管理
* 前台进程 (Interactive Process)：你需要跟它交互。比如你打开 vim 编辑器，或者运行 ls 命令，它们需要你输入指令，结果会直接显示在屏幕上。
* 守护进程 (Daemon)：它脱离于终端（Terminal），在后台默默运行

| 命令        | 是否杀进程 | 操作对象        | 匹配方式            | 默认信号         | 风险等级 | 典型用途              |
| --------- | ----- | ----------- | --------------- | ------------ | ---- | ----------------- |
| `kill`    | 是     | 单个 / 多个 PID | **PID 精确匹配**    | SIGTERM (15) | ⭐    | 精准结束指定进程（最安全）     |
| `pgrep`   | 否     | PID         | 进程名 / 命令行 / 用户  | 无            | ⭐    | 查找进程，配合 `kill` 使用 |
| `pkill`   | 是     | 多个 PID      | 条件匹配（同 `pgrep`） | SIGTERM (15) | ⭐⭐   | 按条件批量结束进程         |
| `killall` | 是     | 多个进程        | **进程名匹配**       | SIGTERM (15) | ⭐⭐⭐⭐ | 一次性结束同名进程（慎用）     |

参数

| 参数        | 适用命令                   | 作用               |
| --------- | ---------------------- | ---------------- |
| `-9`      | kill / pkill / killall | 发送 SIGKILL（强制杀死） |
| `-15`     | kill / pkill / killall | 显式发送 SIGTERM     |
| `-f`      | pgrep / pkill          | 匹配完整命令行          |
| `-u user` | pgrep / pkill          | 按用户筛选进程          |
| `-l`      | kill                   | 列出信号名称           |

常用信号
The most commonly used signals are:

Signal	Description
- 1	SIGHUP - This is sent to a process when the terminal that controls it is closed.
- 2	SIGINT - Sent when a user presses [Ctrl] + C in the controlling terminal to interrupt a process.
- 3	SIGQUIT - Sent when a user presses [Ctrl] + D to quit.
- 9	SIGKILL - Immediately kill a process with no clean-up operations.
- 15	SIGTERM - Program termination.
- 19	SIGSTOP - Stop the program. It cannot be handled anymore.
- 20	SIGTSTP - Sent when a user presses [Ctrl] + Z to request for a service to suspend. The user can handle it afterward.
  
## fg 和bg

把刚启动的扫描或进程放到后台运行，这样当前终端就还能继续使用，比如执行其他命令或者启动新进程。目的：不会阻塞终端，可以同时操作系统其他功能。

可以通过快捷键 Ctrl + Z 来实现。Ctrl + Z 不是直接把进程放到后台运行，而是 暂停（suspend）当前进程。当按下 Ctrl + Z 时，实际上是向内核发送了 SIGTSTP 信号。内核收到信号后会 暂停进程的执行，进程暂时停止，占用的资源仍保留，但不再运行。此时，进程在 暂停状态，可以用 bg 命令把它放到后台继续运行，或者用 fg 把它恢复到前台。

不过如果直接ctrl+z是暂停的，可以在命令末尾加上 &，会让这个命令 立即在后台执行。与 Ctrl + Z + bg 不同，这种方式 从一开始就不占用前台终端。

## 命令并行符

- 分号 ;:不管前一个命令成功还是失败, 依旧按顺序执行命令
- 双与号 &&: 后一条命令只有在前一条命令成功时才执行
- 管道 |: 用于命令链处理数据流，通常用于过滤、统计、转换等操作, 前一个命令的标准输出传递给下一个命令作为标准输入

# 3. 定时任务
## systemd
Systemd 是一个系统和服务管理器，它为现代Linux操作系统提供了一种统一的方式来管理和启动守护进程。Systemd 服务，通常以 .service 文件存在，是Systemd的核心概念之一。这些服务文件定义了如何启动和管理服务，包括它们的启动顺序、依赖关系和执行的命令。

Systemd 是现代 Linux 系统的核心组件，用于管理系统启动和后台服务。Timer 是 Systemd 的一种单元（Unit），专门用来触发事件（通常是触发另一个 Service 服务）。
在以下三种情况下，你必须运行 sudo systemctl daemon-reload，否则你的修改不会生效：
- 新建文件时： 当你刚刚创建了一个新的 .service 或 .timer 文件（Timer必须配置）
- 修改文件时： 当你更改了现有配置文件的内容（比如把 OnBootSec=3min 改成了 5min）。
- 删除文件时： 当你删除了某个服务文件，想要系统知道该服务已经不存在了。

## Timer和Cron对比
|特性        |,Cron (老牌经典)        |,Systemd Timer (现代标准)        |
| --------- | ---------------------- | ---------------- |
配置文件      |单个文件/一行代码 (crontab -e)      |两个文件 (.timer + .service)
上手难度      |⭐ 简单 (适合初学者)      |⭐⭐⭐ 较复杂 (需要理解 Systemd 逻辑)
时间精度      |分钟级      |秒/微秒级 (甚至更精确)
依赖管理      |无 (不管网络/磁盘是否就绪，到点就跑)      |强 (可以设置 After=network.target，等连网了再跑)
日志记录      |较差 (通常发邮件或写入庞大的 syslog)      |极好 (统一用 journalctl 查看，支持结构化查询)
错过补跑      |需要配合 Anacron 工具      |原生支持 (设置 Persistent=true 即可补跑)
资源限制      |难 (需要额外工具)      |原生支持 (可直接限制 CPU/内存使用量)

* 在 Systemd 中，需要写两个文件（.timer 和 .service），而在 Cron 中，只需要在 crontab 文件里写一行代码。
  
```
 *    *    *    *    *    /path/to/script.sh
 ┬    ┬    ┬    ┬    ┬    ──────────────────
 │    │    │    │    │           │
 │    │    │    │    │    要运行的命令或脚本
 │    │    │    │    │
 │    │    │    │    └─ 星期 (0 - 7) (0和7都是周日)
 │    │    │    └────── 月份 (1 - 12)
 │    │    └─────────── 日期 (1 - 31)
 │    └──────────────── 小时 (0 - 23)
 └───────────────────── 分钟 (0 - 59)
```

# 4. Network Service
- ssh
- nfs: 网络文件系统，管理员使用 NFS 集中存储和管理文件（适用于 Linux 和 Windows 系统），以便方便地协作和管理数据。对于Linux，有多个NFS服务器，包括NFS-UTILS（）、NFS-Ganesha（和OpenNFS）。NFSUbuntuSolarisRedhat Linux。用于高效共享和管理资源，例如在服务器间复制文件系统。它还提供访问控制、实时文件传输以及支持多用户同时访问数据等功能。配置文件为/etc/exports。权限包括：
|Permissions        |Description        |
| --------- | ---------------------- |
rw      | 共享文件的read and write
ro      | 共享文件read only
no_root_squash      | 保留客户端 Root 用户的超级管理员身份。
root_squash      | 不保留客户端 Root 用户的超级管理员身份。
sync      |    同步写入，同步数据传输，以确保更改仅在文件系统保存后才被传输。
async      |   异步写入，数据只要到了内存里，就算成功
- apache配置文件: /etc/apache2/ports.conf