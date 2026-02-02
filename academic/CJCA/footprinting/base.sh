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

# 查询域名的SOA记录
dig soa www.inlanefreight.com
# 查询某个域名的 NS（Name Server）记录，查询这个域名是由哪些 DNS 服务器负责解析的？，多解析器的情况可以增加攻击面
dig ns inlanefreight.htb @10.129.14.128
# 解析DNS resovler的IP地址
dig ns1.example.com A
# DNS 服务器指纹识别，CH 类主要被 DNS 服务器用来提供自身信息，DNS 记录不仅有“类型（A/MX/TXT）”，还有一个“类别（Class）”字段
dig CH TXT version.bind 10.129.120.85 # IP为DNS 服务器地址
# 查询某个域名的所有记录
dig any inlanefreight.htb @10.129.14.128
# 记录同步尝试，注意AXFR不是递归的，需要一个一个域名去尝试
dig axfr inlanefreight.htb @10.129.14.128

#递归爆破子域名
for sub in $(cat /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt);do dig $sub.inlanefreight.htb @10.129.14.128 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
# 使用 dnsenum爆破
dnsenum --dnsserver 10.129.14.128 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb

# 连接smtp
telnet 10.129.14.128 25
# 使用 nmap 的 smtp-open-relay 脚本检测 SMTP 服务器是否配置为开放中继（允许行为：攻击者 → 你的SMTP → 帮我把邮件转发给另一个外部邮箱），导致垃圾邮件滥用
nmap 10.129.14.128 -p25 --script smtp-open-relay -v
# 使用 smtp-user-enum 工具进行 SMTP 用户枚举，-M VRFY 指定使用 VRFY 方法，-U 指定用户名列表文件，-t 指定目标 SMTP 服务器 IP 地址，-m 和 -w 分别设置最大尝试次数和并发数
smtp-user-enum -M VRFY -U ./footprinting-wordlist.txt -t STMIP -m 60 -w 20

# curl 连接 imap 服务 -k 允许不验证SSL证书, -u 获取邮件列表
curl -k 'imaps://10.129.14.128' --user user:p4ssw0rd
# 使用 openssl 连接 pop3s 服务
openssl s_client -connect 10.129.14.128:pop3s
# 使用 openssl 连接 imaps 服务
openssl s_client -connect 10.129.14.128:imaps

# SNMP
cat /etc/snmp/snmpd.conf | grep -v "#" | sed -r '/^\s*$/d'
# 使用 snmpwalk 工具进行 SNMP 枚举，-v2c 指定使用 SNMP 版本 2c，-c public 指定使用公共团体community string字符串 "public"，
snmpwalk -v2c -c public 10.129.14.128
# 使用 snmp-check 工具进行 SNMP 枚举，一般默认出厂设置是使用公共团体字符串 "public"只读，或者“private”读写。但是如果管理员修改过团体字符串，则需要使用正确的团体字符串才能成功连接。
sudo apt install onesixtyone
onesixtyone -c /opt/useful/seclists/Discovery/SNMP/snmp.txt 10.129.14.12
# 使用crunch编写字典，crunch用法：-f 指定字符集文件，lalpha-numeric-symbol14表示小写字母、数字和符号，长度在4到8之间，-o指定输出文件名
crunch 4 8 -f /usr/share/crunch/charset.lst lalpha-numeric-symbol14 -o snmp.txt
# Braa虽然没有onesixtyone那么快，但是可以爆破 + 查询 OID，需要onesixtyone配合使用,先爆破出来 community string 再用 braa 查询 OID 信息/
# braa比snmpwalk更强大，噪音更小，并发度更高，还支持多种输出格式。snmpwalk会直接做递归查询，流量较大且容易被检测到。
sudo apt install braa
braa <community string>@<IP>:.1.3.6.*
braa public@10.129.14.128:.1.3.6.*

# mysql配置
sudo apt install mysql-server -y
cat /etc/mysql/mysql.conf.d/mysqld.cnf | grep -v "#" | sed -r '/^\s*$/d'

#mssql枚举
nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 10.129.201.248
# 使用 mssqlclient 连接到 MSSQL 服务器，-windows-auth 表示使用 Windows 身份验证，-target-ip 指定目标 IP 地址，-username 和 -password 分别指定用户名和密码
python3 mssqlclient.py Administrator@10.129.201.248 -windows-auth