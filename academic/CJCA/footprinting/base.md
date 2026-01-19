# 逻辑

| 层	| 描述	| 信息分类| 
| -------- | --------------------------------- | ---------------------------- |
| 1. Internet Presence	| 识别互联网存在和外部可访问基础设施。	| 域名、子域名、虚拟主机、ASN、网络块、IP地址、云实例、安全措施| 
| 2. Gateway	| 识别可能的安全措施，以保护公司的外部和内部基础设施。	| 防火墙、DMZ、IPS/IDS、EDR、代理、NAC、网络分段、VPN、Cloudflare| 
| 3. Accessible Services	| 识别可访问的接口和服务，这些服务托管在外部或内部。	| 服务类型、功能、配置、端口、版本、接口| 
| 4. Processes	| 识别与服务相关的内部进程、源和目的地。	| PID、处理数据、任务、源、目的| 
| 5. Privileges	| 识别可访问服务的内部权限和权限。	| 组、用户、权限、限制、环境| 
| 6. OS Setup	| 识别内部组件和系统配置。	| 作系统类型、补丁级别、网络配置、作系统环境、配置文件、敏感私有文件| 

# Internet Presence
1. 从ssl证书角度出发：SSL certificate查来源有哪些域名，使用https://crt.sh/
2. dns查询搜索的域名，host（快速查询a记录的存活host）和dig命令（详细返回和CDN调度检查），
   - A记录：我们通过A记录识别指向特定（子）域名的IP地址。
   - MX 记录：邮件服务器记录告诉我们哪家邮件服务器负责处理该公司的电子邮件。
   - NS 记录：这类记录显示用于将完全限定域名（FQDN）解析为 IP 地址的权威域名服务器。大多数托管商会使用自己的 NS，因而能更容易地识别出托管商是谁。
   - TXT 记录：这种记录通常包含面向不同第三方服务商的验证密钥，以及 DNS 的其他安全要素

# Cloud
云存储对应
- Amazon (AWS) - S3 buckets
- Google (GCP) - cloud storage
- Microsoft (Azure) -  blobs

通过云储存搜索文件google dork高级语法
inurl:amazonaws.com and intext:dns的txt
inurl:blob.core.windows.net and intext:dns的txt

## 终端里进行搜索引擎搜索的方式
1. lynx: 简易上古浏览器
2. googler:封装的google搜索

## 域名检查
- Domain.Glass：国外版站长之家
- GrayHatWarfare：在线搜索引擎，专门对互联网上公开暴露的 Amazon S3 存储桶（Bucket）及文件进行持续爬取与索引，用户可通过关键词、文件后缀、正则表达式等方式快速定位这些云存储资源。其核心定位是“云存储侧漏雷达”

# 主机服务枚举
- FTP：TCP 21端口是control channel,数据交换在TCP 20（仅主动模式用）。模式包含： active and passive。高危用户anonymous
  - 在活动模式（active mode）中，数据通道TCP 20可能会，被客户端防火墙拦截如果没放行。因为是服务器20 -> 客户端port，流量入被拦截。
  - 被动模式种，是服务器指定动态port等待客户端回连。客户端port -> 服务器port，流量出不拦截。
- TFTP（Trivial File Transfer Protocol）