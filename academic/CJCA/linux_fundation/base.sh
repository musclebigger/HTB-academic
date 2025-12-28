#File Descriptors and Redirections文件描述符和重定向

# Find Files and Directories
# 最快用这个
locate *.conf
# 搜文件链接
which python
# find
# -type f 文件类型
# -name *.conf 文件名
# -user root 拥有者
# -size +20k 文件大小
# -newermt 2020-03-03 指定文件最晚创建日期
# -exec ls -al {} \;展开内容
# 2>/dev/null 不显示错误
find / -type f -name *.conf -user root -size +20k -size -28k -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
# 计数
# 文件描述符2 STDERR 重定向到 /dev/null垃圾处理（windows垃圾桶），只看标准输出，这里2>/dev/null只要在一个命令管道里，位置随意
find / -name "*.bak" 2>/dev/null | wc -l
# 这里如果直接是find / -name "*.bak" >result.txt就是默认是1（输出结果）
find / -name "*.bak" 1>result.txt
# 输出到文件，包括错误，，重定向里出现 & + 数字，就表示“复制已打开的文件描述符”，这里>results.txt第一步执行时已打开了1（STDOUT），所以2>&1表示把2（STDERR）重定向到1（STDOUT）所指向的地方，在一个步骤里完成
find /etc -name shadow >results.txt 2>&1
# 分开
find /etc -name shadow 1>ok.txt 2>err.txt
# 只看报错
find /etc -name shadow 2>errors.txt
# 对找到的每个文件执行命令，{} 代表当前找到的文件路径，\; 告诉 find “命令结束”
find / -name 'proftpd.conf' -exec cat {} \; 2>/dev/null
# <是将磁盘数据重定向到程序的STDIN，也可以简写成<
cat 0< stdout.txt # 从STDIN读取，换成从stdout.txt读取，也就是将0的文件描述符重定向到stdout.txt

# 拔插3号位
exec 3< stdout.txt

# >>进行追加，>进行覆盖
echo "hello world" >> stdout.txt
find /etc/ -name passwd >> stdout.txt 2>/dev/null

# << 是在脚本里进行多行输入，某个“结束词”告诉系统“到这儿就停”，行业规范一般是EOF
cat <<EOF > a.txt
first line
second line
EOF

# 管道符是另一种STDOUT重定向,把一个命令的输出作为另一个命令的输入
find /etc/ -name *.conf 2>/dev/null | grep systemd | wc -l

# 统计已安装包数量
dpkg -l | grep 'ii' | wc -l

## Filter Contents内容过滤
# more比 cat 温和,可以分页显示,q键退出
more file.txt | less # less比more更强大
sort file.txt | uniq  # 排序并去重
grep 'pattern' file.txt  # 查找包含pattern的行
grep -i 'pattern' file.txt  # 忽略大小写查找
grep -r 'pattern' /path/to/dir  # 递归查找目录
grep -v 'pattern' file.txt  # 查找不包含pattern的行

# 使用cut，f1表示第一列，-d指定分隔符位：":"， 使用grep多选需要用\|表示或
cat /etc/passwd | grep -v "false\|nologin" | cut -d":" -f1 

# 使用tr替换分隔符，将：替换为空格，tr命令，tr set1替换为set2
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " "
# 大小写互换
echo "Hello" | tr 'a-z' 'A-Z'
# 删除文档中的回车符
tr -d '\r' < file.txt 
# 压缩重复字符
echo "a   b    c" | tr -s ' ' # 输出：a b c
# 生成随机口令
tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16

# Column命令，将文本按列对齐显示
column -t file.txt
cat /etc/passwd | grep -v "false\|nologin" | tr ":" " " | column -t

# Awk命令，按列处理文本，默认分隔符是空格，$1表示第一列，$2第二列，$NF表示最后一列
awk '{print $1, $NF}' file.txt # 输出第一列和最后一列

# Sed命令，流编辑器，用于文本替换, s/表示替换，g表示全局替换, 能处理文件支持正则，但是比tr慢
sed 's/old/new/g' file.txt # 将文件中的old替换为new
# 删除空行
sed '/^$/d' file
sed 's/hello world/hi universe/g' file   # sed 能做多字符
# tr 无法完成，只能逐字符换，会乱套

# 统计网页中某个域名的链接数量，tr将单引号和双引号替换为换行符，再grep筛选出包含域名的行，sort -u去重，wc -l计数
curl https://www.inlanefreight.com -k -s | tr "'" "\n" | tr '"' '\n' | grep "https://www.inlanefreight.com" | sort -u | wc -l

## Regular Expressions正则表达式
grep -E # 支持正则
grep -E "(my|false)" /etc/passwd # 或
grep -E "(my.*false)" /etc/passwd # 与
# ^ 开头 $ 结尾 . 任意字符 * 前一个字符出现0次或多次 + 前一个字符出现1次或多次 ? 前一个字符出现0次
grep -E "^root.*:\/bin\/bash$" /etc/passwd
# {n} 前一个字符出现n次 {n,} 前一个字符出现至少n次 {n,m} 前一个字符出现n到m次
grep -E "a{3}" file.txt # aaa


# 权限管理
chmod a+r file.txt # 所有人可读，a是all
chmod u+w file.txt # 拥有者可写，u是user
chmod g+x file.txt # 组用户可执行，g是group
chmod o-r file.txt # 其他用户不可读，o是others
chmod 755 file.txt # 数字表示权限，7是rwx，5是r-x，0是无权限
# 换owner，chown <user>:<group> <file/directory>
chown root:root file.txt