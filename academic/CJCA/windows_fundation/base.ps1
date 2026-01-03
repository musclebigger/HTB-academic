# windows系统查看版本
Get-WmiObject -Class win32_OperatingSystem | select Version,BuildNumber
