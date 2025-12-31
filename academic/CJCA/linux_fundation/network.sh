# 激活一个以太网接口 eth0
sudo ifconfig eth0 up
# 设置 eth0 的 IP 地址为 100
sudo ifconfig eth0 192.168.1.100
# 子网掩码
sudo ifconfig eth0 netmask 255.255.255.0
# 默认网关
sudo route add default gw 192.168.1.1 eth0
# 编辑网络配置文件
nano /etc/network/interfaces
# 在文件中添加以下内容以配置静态 IP 地址
auto eth0
iface eth0 inet static
  address 192.168.1.2
  netmask 255.255.255.0
  gateway 192.168.1.1
  dns-nameservers 8.8.8.8 8.8.4.4

# 保存并退出编辑器后，重启网络服务以应用更改
sudo systemctl restart networking

# 看哪些端口在监听, t是tcp, u是udp, l是监听, n是数字显示端口号, p显示进程pid
netstat -tulnp
netstat -a # 显示所有连接和监听端口

# 本地有输出（如 :0、:1） → ✅ 一定有 X Server 在运行
echo $DISPLAY
# 查看x11配置
cat /etc/ssh/sshd_config | grep X11Forwarding
# 机器连接远程X11，启动远程的firefox浏览器,X11只能用远程的非root用户连接
ssh -X htb-student@10.129.23.11 /usr/bin/firefox
# X11端口转发，将远程服务器的8080端口转发到本地的8080端口
ssh -L 8080:localhost:8080 frank@156.227.236.165

#TigerVNC Installation安装全过程
sudo apt install xfce4 xfce4-goodies tigervnc-standalone-server -y
vncpasswd # 设置vnc密码
touch ~/.vnc/xstartup ~/.vnc/config # 配置文件
# 配置vnc启动xfce4桌面环境
cat <<EOT >> ~/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
x-window-manager &
EOT

# 配置vnc分辨率和dpi
cat <<EOT >> ~/.vnc/config

geometry=1920x1080
dpi=96
EOT
# 赋予执行权限
chmod +x ~/.vnc/xstartup
# 启动vnc服务
vncserver
# 查看vnc服务状态
vncserver -list
# 本地通过ssh本地端口转发连接vnc服务，假设vnc服务运行在远程主机的5901端口
ssh -L 5901:127.0.0.1:5901 -N -f -l htb-student 10.129.14.130
# 本地使用vncviewer连接
xtightvncviewer localhost:5901