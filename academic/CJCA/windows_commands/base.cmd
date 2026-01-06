icacls #change_permissions
icacls c:\users /grant joe:f # 授予权限

sc qc wuauserv #查询服务配置
sc start wuauserv #启动服务
sc stop wuauserv #停止服务

sc config wuauserv binPath=C:\Winbows\Perfectlylegitprogram.exe # 更改服务二进制路径,劫持启动项，需要当前用户对该服务有 SERVICE_CHANGE_CONFIG 权限

sc sdshow wuauserv # 显示服务的安全描述符
sc sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;WD) # 设置服务的安全描述符，WD表示允许所有用户启动该服务

wmic os list brief # 列出操作系统信息
wmic service get name,displayname,pathname,startmode,state # 列出服务信息