# curl通过HTTP基本认证访问指定URL
curl -u admin:admin http://<SERVER_IP>:<PORT>/
# 或者不用参数直接写在URL中
curl http://admin:admin@<SERVER_IP>:<PORT>/
# 或者 -v 参数查看详细请求信息
curl -v -u admin:admin http://<SERVER_IP>:<PORT>/

# -k参数忽略SSL证书验证https
curl -k -u admin:admin https://<SERVER_IP>:<PORT>/
# -I 参数只获取响应头信息
curl -I -u admin:admin http://<SERVER_IP>:<PORT>/