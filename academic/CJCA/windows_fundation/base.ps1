# windows系统查看版本
Get-WmiObject -Class win32_OperatingSystem | select Version,BuildNumber

# 查看当前目录，相当于pwd
Get-Location
# 查看子目录
Get-ChildItem
# 切换目录
Set-Location
# 读文件
Get-Content Readme.md

# 查看powershell的命令的详细信息， -verb 参数可以筛选动词, -noun 参数可以筛选名词
Get-Command -Verb 
# 查看powershell命令历史
Get-History
# 查看历史命令
get-content C:\Users\DLarusso\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt

# 获或者取 PSReadLine 历史目录
$historyDir = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine"
# 列出目录下文件，查看历史记录
Get-ChildItem $historyDir

# 查看缩写
 Get-Alias
# 修改缩写,ft缩写做成table，fl做成map
 Set-Alias -Name gh -Value Get-Help

# 导入当前目录下的所有模块，排除Tests和docs目录
 Get-ChildItem $PSScriptRoot | ? { $_.PSIsContainer -and !('Tests','docs' -contains $_.Name) } | % { Import-Module $_.FullName -DisableNameChecking }
# 查看已导入的模块
 Get-Module -ListAvailable
# 查看执行策略
 Get-ExecutionPolicy 
# 修改执行策略为undefined，解除限制
 Set-ExecutionPolicy undefined
# 解除限制后，批量导入
Import-Module .\PowerSploit.psd1

# 非永久性导入
Set-ExecutionPolicy -Scope Process

# 查看命令
Get-Command -Module PowerSploit
# powershellget是用来管理powershell模块的
Get-Command -Module PowerShellGet
# admintoolbox是一个常用的模块，用于域控
Find-Module -Name AdminToolbox

# 安装admintoolbox模块
Find-Module -Name AdminToolbox|Install-Module

# 会在我们的主机上显示用户。这些用户只能访问该主机。
Get-LocalUser

# 创建本地用户
New-LocalUser -Name "JLawrence" -NoPassword
# 创建密码
$Password = Read-Host -AsSecureString "Enter Password"
# 推送密码
Set-LocalUser -Name "JLawrence" -Password $Password -Description "CEO EagleFang"
# 添加本地用户组
 Add-LocalGroupMember -Group "Remote Desktop Users" -Member "JLawrence"
 Get-LocalGroupMember -Name "Remote Desktop Users" # 查看

# 安装域控RSAT工具
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
# 查看已安装的ActiveDirectory模块
Get-Module -Name ActiveDirectory -ListAvailable

# RAST工具包, 查看域用户
Import-Module ActiveDirectory 
Get-ADUser -Filter {GivenName -like 'robert'}
Get-ADUser -Filter *
# 查看指定用户信息
Get-ADUser -Identity TSilver
# 通过邮箱域名筛选用户
Get-ADUser -Filter {EmailAddress -like '*greenhorn.corp'}

# 添加新AD用户
New-ADUser -Name "MTanaka" -Surname "Tanaka" -GivenName "Mori" -Office "Security" -OtherAttributes @{'title'="Sensei";'mail'="MTanaka@greenhorn.corp"} -Accountpassword (Read-Host -AsSecureString "AccountPassword") -Enabled $true 
# 更改AD用户信息
Set-ADUser -Identity MTanaka -Description " Sensei to Security Analyst's Rocky, Colt, and Tum-Tum"

# 创建内容
Add-Content .\Readme.md "Title: Insert Document Title Here
>> Date: x/x/202x
>> Author: MTanaka
>> Version: 0.1 (Draft)"

# 重命名
 Rename-Item .\Cyber-Sec-draft.md -NewName Infosec-SOP-draft.md
# 批量修改
get-childitem -Path *.txt | rename-item -NewName {$_.name -replace ".txt",".md"}

# 查看管理员obejct的属性，所有的
Get-LocalUser administrator | get-member
# 通过get-obejct查看属性
Get-LocalUser administrator | Select-Object -Property *

# 按照启用状态分组显示本地用户，group-object用于分组
Get-LocalUser * | Sort-Object -Property Name | Group-Object -property Enabled

# 查看Windows Defender服务状态，查找的是object
Get-Service | where DisplayName -like '*Defender*'