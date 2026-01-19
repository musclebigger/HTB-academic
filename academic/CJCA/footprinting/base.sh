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
