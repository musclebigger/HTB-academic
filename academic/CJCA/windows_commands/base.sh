smbclient '\\SERVER_IP\Company Data' -U htb-student # 连接到共享文件夹
smbclient -L SERVER_IP -U htb-student # 列出共享资源
smbclient '//SERVER_IP/C$' -U htb-student #尝试连接到管理员共享

# 挂载共享文件夹到本地目录，需要安装cifs-utils，作用是将远程共享文件夹映射到本地文件系统
sudo mount -t cifs -o username=htb-student,password=Academy_WinFun! //ipaddoftarget/"Company Data" /home/user/Desktop/
# 成功挂在后
net share # 查看本地共享
sudo umount /home/user/Desktop/ # 卸载共享文件夹

# 安装X11应用程序以测试X11转发，让wsl应用显示在主机上
apt install x11-apps -y

xfreerdp /v:10.129.108.183 /u:htb-student /p:Academy_WinFun! /dynamic-resolution