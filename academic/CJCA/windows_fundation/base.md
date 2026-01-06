# Boot下的文件夹
- Perflogs：存放 Windows 性能日志（Performance Logs）
- Program Files：程序安装目录，系统默认路径，很多安装器会自动选择
- Program Files (x86)：在 64 位 Windows 上安装 32 位和 16 位程序
- ProgramData：隐藏文件夹，存放程序运行所需的共享数据。常用于存储许可证文件、配置文件、共享缓存
- Default用户目录：新用户登录时的模板
- AppData：每个用户的程序数据（隐藏目录），用户配置和缓存都在这里。Roaming：跨设备同步的用户数据（如自定义字典、配置），Local：本机专用数据，不同步，LocalLow：低完整性级别，用于安全模式下浏览器等
- Windows：操作系统核心文件目录
- System, System32, SysWOW64：存放核心 DLL 和 Windows API 文件
- WinSxS：Windows 组件存储，所有系统组件、更新、补丁
# access 命令
- 本地cmd：C:\Windows\System32\cmd.exe
- 远程：telnet(insecure and not recommended), Secure Shell (SSH), PsExec, WinRM, RDP

# 快捷指令
| 按键 / 命令 | 说明 |
|------------|------|
| `doskey /history` | `doskey /history` 会将当前会话中的命令历史打印到终端，或在指定参数时输出到文件。 |
| Page Up | 将当前会话历史中的第一条命令放入命令提示符中。 |
| Page Down | 将命令历史中的最后一条命令放入命令提示符中。 |
| ⇧（上箭头） | 向上滚动命令历史，查看之前执行过的命令。 |
| ⇩（下箭头） | 向下滚动命令历史，查看最近执行过的命令。 |
| ⇨（右箭头） | 将上一条命令逐字符地输入到命令提示符中。 |
| ⇦（左箭头） | 不适用（N/A）。 |
| F3 | 将上一条命令完整地重新输入到命令提示符中。 |
| F5 | 多次按下 F5 可以循环浏览之前执行过的命令。 |
| F7 | 打开一个交互式的历史命令列表。 |
| F9 | 根据输入的编号，将对应编号的历史命令输入到命令提示符中（编号对应命令在历史中的位置）。 |

# 常见目录
| 名称 | 路径 | 说明 |
|------|------|------|
| `%SYSTEMROOT%\Temp` | `C:\Windows\Temp` | 全局系统临时目录，所有用户都可访问。无论权限高低，用户在该目录中通常拥有读、写、执行权限。对低权限用户投放文件非常有用。 |
| `%TEMP%` | `C:\Users\<user>\AppData\Local\Temp` | 用户级临时目录，仅当前用户可访问。目录所有权属于对应用户。攻击者获得本地/域用户账户控制权后较为有用。 |
| `%PUBLIC%` | `C:\Users\Public` | 公共目录，任何交互式登录账户都可对其中的文件和子目录进行读、写、修改、执行等操作。可作为 Windows 全局 Temp 目录的替代方案，且通常较少被监控可疑活动。 |
| `%ProgramFiles%` | `C:\Program Files` | 存放系统中安装的所有 64 位应用程序。可用于判断目标系统上安装了哪些软件。 |
| `%ProgramFiles(x86)%` | `C:\Program Files (x86)` | 存放系统中安装的所有 32 位应用程序。可用于判断目标系统上安装了哪些软件。 |

# 搜索windows系统
![alt text](image.png)

# 文件查找
- where 是“找文件路径”的
- find 是“在内容里找字符串”的

# 环境变量
| 范围 | 描述 | 访问所需权限 | 登记地点 |
|------|------|--------------|----------|
| System (Machine) | 系统作用域包含作系统（OS）定义的环境变量，所有登录系统的用户和账户均可全局访问。作系统要求这些变量正常工作，并在运行时加载。 | 本地管理员或域管理员 | HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment |
| User | 用户范围包含当前活跃用户定义的环境变量，仅对他们开放，其他能登录同一系统的用户则无法访问。 | 当前活跃用户、本地管理员或域管理员 | HKEY_CURRENT_USER\Environment |
| Process | 进程作用域包含在当前运行进程上下文中定义和访问的环境变量。由于它们是短暂的，它们的寿命仅持续到最初定义的当前运行过程。它们还继承系统/用户作用域及其生成的父进程的变量（仅当父进程是子进程时）。 | 当前子进程、父进程或当前活跃用户 | None (Stored in Process Memory) |


重要的环境变量：
| 变量名称 | 描述 |
|----------|------|
| %PATH% | 指定可执行程序所在的一组目录（位置），系统会在这些路径中查找可执行文件。 |
| %OS% | 当前用户工作站正在运行的操作系统。 |
| %SYSTEMROOT% | 系统定义的只读变量，包含 Windows 系统目录。Windows 核心功能依赖这里的文件，包括重要数据、系统核心二进制文件和配置文件。通常为 `C:\Windows`。 |
| %LOGONSERVER% | 提供当前活跃用户的登录服务器以及机器主机名。可用于判断机器是否加入域（Domain）或工作组（Workgroup）。 |
| %USERPROFILE% | 提供当前活跃用户的主目录路径，通常为 `C:\Users\{username}`。 |
| %ProgramFiles% | 包含系统上所有 64 位程序的安装目录，通常为 `C:\Program Files`。 |
| %ProgramFiles(x86)% | 包含系统上所有 32 位程序的安装目录（仅在 64 位系统可用），通常为 `C:\Program Files (x86)`。可用于判断主机架构（x86 vs x64）。 |

# cmd & powershell
cmd更隐蔽

powershell，shift+tab可以自动补全命令，常见快捷键：
# PowerShell 常用快捷键

| 快捷键 | 描述 |
|--------|------|
| CTRL+R | 让历史命令可搜索。在之后输入命令时，会显示与之前命令匹配的结果。 |
| CTRL+L | 快速清屏。 |
| CTRL+ALT+Shift+? | 打印 PowerShell 能识别的全部快捷键列表。 |
| Escape | 在 CLI 中输入时，按 Escape 可以清除整行，无需按空格。 |
| ↑ | 向上翻阅之前的历史命令。 |
| ↓ | 向下翻阅之前的历史命令。 |
| F7 | 调出一个可滚动互动的历史命令列表（TUI）。 |
