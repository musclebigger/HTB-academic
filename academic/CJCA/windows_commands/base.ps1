 Get-Service | ? {$_.Status -eq "Running"} | select -First 2 |fl # 获取前两个正在运行的服务，fl是格式化输出
 Get-Process | select -First 2 | fl # 获取前两个进程

 Get-ACL -Path HKLM:\System\CurrentControlSet\Services\wuauserv | Format-List # 获取Windows Update服务的权限

 Get-ExecutionPolicy -List # 列出所有作用域的执行策略
 Set-ExecutionPolicy Bypass -Scope Process # 临时设置当前会话的执行策略为Bypass

 Get-Alias -Definition 'ipconfig' # 查找ipconfig命令的别名

# 获取操作系统的系统目录、构建号、序列号和版本信息，通过WMI对象
Get-WmiObject -Class Win32_OperatingSystem | select SystemDirectory,BuildNumber,SerialNumber,Version | ft

# 重命名C盘Public文件夹下的spns.csv文件为kerberoasted_users.csv，通过WMI方法
Invoke-WmiMethod -Path "CIM_DataFile.Name='C:\users\public\spns.csv'" -Name Rename -ArgumentList "C:\Users\Public\kerberoasted_users.csv"
# 安装WSL（Windows Subsystem for Linux）
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# 安装后更新
wsl --update
# wsl --install # 安装默认的Linux发行版
wsl --install -d Ubuntu
# 启动WSL
wsl.exe -d Ubuntu
# 查看实例
wsl -l -v
# 进入实例
wsl -d Ubuntu

# 查看Microsoft Defender的计算机状态
Get-MpComputerStatus

# 查询当前用户启动项的注册表键值关于启动批准的信息
Reg Query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"