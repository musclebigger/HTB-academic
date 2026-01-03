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
