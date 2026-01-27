# !/bin/bash
# Script to fetch and display certificate information for inlanefreight.com from crt.
# jq是一个轻量级且灵活的命令行JSON处理器，类似于sed用于JSON数据。
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq .

# 通过唯一子域名进行过滤, gsub 是全局替换函数,第一个参数 /\\n/ 是正则表达式，表示匹配换行符，第二个参数 "\n" 是替换字符串，表示将匹配到的换行符替换为实际的换行符。
# 1,awk 的“模式-动作”语法。1 永远为真，相当于默认动作 {print}，即把处理后的整行打印出来。在 awk 里，{} 是“动作（action）块”的唯一语法标记；没有它，awk 就无法区分“模式”和“动作”。
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u

# host 是一个 DNS 查询小工具，作用跟 nslookup、dig 类似，但语法更简洁，默认只输出“最常用”的那几类记录（A、AAAA、MX、PTR 等）。
host inlanefreight.com

# shodan 是一个网络空间搜索引擎，可以用来查找特定域名或 IP 地址的相关信息。
shodan host inlanefreight.com

# DNS Records 查询记录，ANY表示查询所有类型记录，+noall表示不显示默认信息，+answer表示只显示答案部分
dig inlanefreight.com ANY +noall +answer

# 用 EDNS Client Subnet 看不同地区返回的节点；host 不支持 EDNS 选项。检查CDN节点分布情况，可以用来判断目标是否使用了CDN服务
dig example.com @1.1.1.1 +subnet=202.96.0.0/24

# 安装 vsftpd FTP 服务器
 apt install vsftpd 

 # 更新 nmap 脚本数据库
 sudo nmap --script-updatedb
 # 查看本地nmap脚本
 find / -type f -name ftp* 2>/dev/null | grep scripts
 # nmap使用脚本，并查看脚本执行
 nmap -sV -p21 -sC -A 10.129.14.136 --script-trace

# 使用 wget 镜像下载 FTP 服务器上的所有文件，--no-passive 选项用于禁用被动模式
wget -m --no-passive ftp://anonymous:anonymous@10.129.14.136
# 通过ssl方式连接FTP服务器
 openssl s_client -connect 10.129.14.136:21 -starttls ftp


# SMB配置文件
cat /etc/samba/smb.conf | grep -v "#\|\;"

# 使用 rpcclient 连接到 SMB 服务器并列出共享资源
rpcclient -U "" 10.129.14.128
# impacket工具集中的Samrdump.py脚本用于从远程Windows系统的SAM数据库中提取用户账户信息。
Impacket - Samrdump.py
# smbmap 工具用于枚举和映射 SMB 共享资源
smbmap -H 10.129.14.128
# crackmapexec 是一个强大的渗透测试工具，专门用于评估和利用 SMB 协议的漏洞。
crackmapexec smb 10.129.14.128 --shares -u '' -p ''

# Enum4Linux-ng 是一个用于枚举 Windows 和 Samba 系统信息的工具，类似于 enum4linux，但功能更强大，支持更多的选项和功能。
git clone https://github.com/cddmp/enum4linux-ng.git
pip3 install -r requirements.txt
./enum4linux-ng.py 10.129.14.128 -A

# 使用rpcinfo NSE脚本
sudo nmap --script nfs* 10.129.14.128 -sV -p111,2049
# 查看可用nfs
showmount -e 10.129.14.128
# 本地连nfs过程，当发现可连的nfs v3以下版本
mkdir target-NFS
sudo mount -t nfs 10.129.14.128:/ ./target-NFS/ -o nolock
cd target-NFS
tree
sudo umount ./target-NFS
