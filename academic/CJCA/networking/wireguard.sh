# 1.1 启用 IP 转发
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf  # 可选 IPv6
sudo sysctl -p

# 1.2 安装必要工具
sudo apt update
sudo apt install wireguard iptables-persistent netfilter-persistent -y

# 2.1 创建 WireGuard 目录
sudo mkdir -p /etc/wireguard
cd /etc/wireguard
umask 077

# 2.2 生成密钥对
wg genkey | sudo tee privatekey | wg pubkey | sudo tee publickey
sudo nano /etc/wireguard/wg0.conf
wg-quick up wg0 

# 2.3 客户端创建密钥对
# 为每个客户端生成密钥
CLIENT_NAME="client1"
mkdir -p /etc/wireguard/clients
wg genkey | tee /etc/wireguard/clients/${CLIENT_NAME}_privatekey | wg pubkey | tee /etc/wireguard/clients/${CLIENT_NAME}_publickey

sudo nano /etc/wireguard/clients/client1.conf
#客户端启动
sudo wg-quick down wg0
wg-quick up wg0

# 调整MTU，如果遇到连接问题，http通，https不通试一下
ping -M do -s 1300 8.8.8.8
ping -M do -s 1470 8.8.8.8
# 如果上面的一个通一个不通，说明https的第一次报文被吞了，要在跳板机上调整
iptables -t mangle -A FORWARD -o tun0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t mangle -A FORWARD -o eth0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu