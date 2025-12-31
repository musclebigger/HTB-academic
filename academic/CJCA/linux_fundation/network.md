# 网络诊断工具
- Ping: 测速和连通性
- Traceroute: 用来判断「是从哪一跳开始不通 / 慢」，显示经过了哪些路由，每一跳hop的延迟
- Netstat
- Tcpdump
- Wireshark
- Nmap

# 安全加固工具
## SELinux
集成在 Linux 内核中的一种 强制访问控制（MAC）机制，用来限制进程和资源能做什么，基于标签（Label-based）

## AppArmor
为每个应用定义一个访问白名单，AppArmor 是 内核级安全机制，无法被普通用户或被攻陷进程绕过。基于路径（Path-based）

## TCP Wrappers
基于主机的网络访问控制机制，通过客户端 IP 地址 来决定是否允许访问某个网络服务。只管“进不进得来”，不管“进来后干什么”
配置文件：
- /etc/hosts.allow
- /etc/hosts.deny
样例：

```
$ cat /etc/hosts.allow
# Allow access to SSH from the local network
sshd : 10.129.14.0/24

# Allow access to FTP from a specific host
ftpd : 10.129.14.10

# Allow access to Telnet from any host in the inlanefreight.local domain
telnetd : .inlanefreight.local
```

## 图解

外部攻击者
   ↓
TCP Wrappers（IP 是否允许？）
   ↓
网络服务（SSH / Web）
   ↓
AppArmor / SELinux（进程能干什么？）
   ↓
系统资源（文件 / 进程 / 网络）

# linux的Remote Desktop Protocols 

## XServer
X11是一个固定的系统，由一系列协议和应用程序组成，允许我们在图形用户界面中调用显示器上的应用程序窗口。X11在Unix系统中占主导地位，但其他操作系统也可以使用X服务器。如今，X服务器几乎是每个Ubuntu及其衍生版本桌面安装的一部分，不需要单独安装。

X 服务器并不依赖于本地计算机，它既可以用来访问其他计算机，也可以被其他计算机用来访问本地的 X 服务器。只要本地和远程计算机都运行 Unix/Linux 系统，就不需要额外的协议（如 VNC 和 RDP）。VNC 和 RDP 是在远程计算机上生成图形输出并通过网络传输，而 X11 则是在本地计算机上进行渲染，这样可以节省网络带宽并减少远程计算机的负载。

然而，X11 的一个显著缺点是数据传输默认不加密。不过，这个问题可以通过 SSH 隧道 来解决。在提供应用程序的服务器上，修改 SSH 配置文件 /etc/ssh/sshd_config，将 X11 转发（X11 forwarding） 选项设置为 yes，以允许通过 SSH 进行 X11 转发。

## X11结构

远程：firefox / xclock
          ↓
      SSH 加密隧道
          ↓
本地：X Server 显示窗口

X11 是“反过来”的架构
|角色	|在哪|
|------------|--------------|
|X Server（显示）|	你的本地电脑|
X Client（程序）	|远程 Ubuntu|


##  X Display Manager Control Protocol (XDMCP) 
UDP port 177，XDMCP 是一种不安全的协议，不应在对安全性要求较高的环境中使用。通过 XDMCP，可以将完整的图形用户界面（GUI）（例如 KDE 或 GNOME）重定向到对应的客户端。

要让一台 Linux 系统作为 XDMCP 服务器运行，服务器上必须安装并配置带有 GUI 的 X 系统。在计算机启动后，用户应当能够在本地看到并使用图形界面。

XDMCP 可能被利用的一种方式是中间人攻击（Man-in-the-Middle, MITM）。在这种攻击中，攻击者拦截远程计算机与 X Window 系统服务器之间的通信，并冒充通信双方之一，从而获得对服务器的未授权访问。随后，攻击者可能利用该服务器执行任意命令、访问敏感数据，或进行其他危害系统安全的操作。

## VNC

管理员利用 VNC 访问那些无法物理接触的计算机，可用于排查和维护服务器、访问其他计算机上的应用程序，或为工作站提供远程访问。VNC 还可用于屏幕共享，让多名用户协作完成项目或共同排查问题。
VNC 服务器有两种不同概念：
- 常见类型直接提供主机的真实屏幕，便于技术支持；由于远程电脑的键盘和鼠标仍可正常使用，建议事先做好安排。
- 另一类服务器程序允许用户登录到虚拟会话，类似终端服务器的概念。

VNC 的服务器和查看器程序适用于所有主流操作系统，因此许多 IT 服务都借助 VNC 完成。专有的 TeamViewer 和 RDP 也有类似用途。
传统上，VNC 服务器监听 TCP 5900 端口，即提供 display 0。其他显示号可通过额外端口提供，通常为 590[x]，其中 x 为显示编号。若需多个并发连接，会依次使用更高的 TCP 端口，如 5901、5902、5903 等。
用于这些 VNC 连接的工具很多，例如：
- TigerVNC
- TightVNC
- RealVNC
- UltraVNC

VNC 安装过程中，系统会在主目录下创建一个名为 .vnc 的隐藏文件夹。接着，我们需要再创建两个文件：xstartup 和 config。
- xstartup 决定 VNC 会话如何与显示管理器配合建立；
- config 则用于设定 VNC 的各项参数。