# 常用用户管理命令
sudo # 以超级用户身份执行命令
su # 切换用户
useradd # 添加用户
useradd -m # 添加用户并创建主目录
userdel # 删除用户
usermod # 修改用户信息
addgroup # 添加用户组
delgroup # 删除用户组
passwd # 修改用户密码
chage # 修改密码过期时间

# 包管理
apt-cache search impacket # 搜索包,apt-cache show impacket # 显示包信息, cache是本地缓存
apt list --installed # 列出已安装包

# 进程管理
pgrep name # 根据名称查找进程ID，类似ps aux | grep name
pkill name # 根据名称终止进程，类似kill $(pgrep name)

kill -1 PID # 重新加载配置
kill -9 PID # 强制终止进程
kill -3 PID # 生成进程转储文件（core dump进程快照,通常在 当前目录 或 /var/lib/systemd/coredump/（取决于系统配置）
gdb /path/to/executable /path/to/corefile # 使用gdb分析core进程快照文件
kill -15 PID # 正常终止进程，默认信号
kill -19 PID # 暂停进程
kill -20 PID # 恢复暂停的进程

# 进程显示
bg # 将暂停的进程放到后台运行，如果命令又&符号则直接后台运行
fg # 将后台进程放到前台运行，使用jobs查看后台任务序号
jobs # 显示当前用户的后台任务，显示序号

# 定时服务创建
sudo mkdir /etc/systemd/system/mytimer.timer.d
sudo vim /etc/systemd/system/mytimer.timer
# 重启守护进程
sudo systemctl daemon-reload

# crond
# 在第 0 分钟（整点）。*每一天,每一周，每月
0 */6 * * * /path/to/update_software.sh # 每6小时执行一次脚本,/ 表示“步长”（Step）。意思是只要小时数能被 6 整除就执行（0, 6, 12, 18）。
0 0 1 * * /path/to/scripts/run_scripts.sh # 每月1号的0点执行脚本


# NFS share
mkdir nfs_sharing
echo '/home/cry0l1t3/nfs_sharing hostname(rw,sync,no_root_squash)' >> /etc/exports
# mount NFS share
mkdir ~/target_nfs # 创建挂载点
mount 10.129.12.17:/home/john/dev_scripts ~/target_nfs # 挂载NFS共享目录
# web服务通过nodejs
sudo npm install --global http-server
http-server -p 8080 # 在当前目录启动web服务，监听8080端口
# php启动web服务
php -S 127.0.0.1:8080
