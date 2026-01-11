#  首先安装openssh
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*' # 查看版本
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 # 安装客户端
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 # 安装服务端
Start-Service sshd # 启动服务
Set-Service -Name sshd -StartupType 'Automatic' # 设置开机自启

# winrm，只要知道访问系统的凭据，任何可以通过网络访问目标的人都可以在该命令运行后进行连接。
# IT 管理员应采取进一步措施来强化这些 WinRM 配置，配置 TrustedHosts，使其仅包含将用于远程管理的 IP 地址/主机名，配置 HTTPS 传输，将 Windows 系统加入 Active Directory 域环境并强制执行 Kerberos 身份验证
winrm quickconfig # 配置winrm，询问是否更改，输入y
# 查看winrm配置
winrm get winrm/config
# 允许远程连接
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
# 重启winrm服务
Restart-Service WinRM
# 允许防火墙通过22端口和5985端口
New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
New-NetFirewallRule -Name "WinRM-HTTP-In-TCP" -DisplayName "Windows Remote Management (HTTP-In)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5985
# 查看防火墙规则
Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP"
Get-NetFirewallRule -Name "WinRM-HTTP-In-TCP"
# 测试远程连接
Test-WsMan -ComputerName "10.129.224.248" # 替换为目标主机IP地址
# 测试远程连接，使用Negotiate认证
Test-WSMan -ComputerName "10.129.224.248" -Authentication Negotiate

# 使用 Enter-PSSession 连接到远程主机，windows和linux都可以使用这个命令
# 官方提供的命令https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enter-pssession?view=powershell-7.5&viewFallbackFrom=powershell-7.2
Enter-PSSession -ComputerName 10.129.224.248 -Credential htb-student -Authentication Negotiate # 查看远程主机的PowerShell版本