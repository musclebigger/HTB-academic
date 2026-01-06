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

