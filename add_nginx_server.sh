#!/bin/bash

# --- 变量设置 ---
# Nginx 配置文件路径
CONFIG_FILE="/etc/nginx/conf.d/chali.conf"
# 要添加的新域名
NEW_DOMAIN="hao.acstudy.icu"
# 模板域名 (用于证书路径替换)
TEMPLATE_DOMAIN="kefu.acstudy.icu"

# --- 检查文件是否存在 ---
if [ ! -f "$CONFIG_FILE" ]; then
    echo "错误: 配置文件 $CONFIG_FILE 不存在！"
    exit 1
fi

# --- 定义新的 HTTPS 服务块内容 ---
# 使用 heredoc 格式定义要添加的配置内容
read -r -d '' NEW_SERVER_BLOCK << EOL
#Take the domain name "${NEW_DOMAIN}" for example
server {
    listen       443 ssl; #listening port
    server_name  ${NEW_DOMAIN}; #Your domain server_name
    #Path of pem file for ssl certificate
    ssl_certificate /etc/nginx/ssl/${NEW_DOMAIN}_bundle.pem;
    #Key file path of ssl certificate
    ssl_certificate_key /etc/nginx/ssl/${NEW_DOMAIN}.key;

    client_max_body_size 50M;

    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_comp_level 2;
    gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png application/wasm;
    gzip_vary off;
    gzip_disable "MSIE [1-6]\.";

    default_type application/wasm;

    location / {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-real-ip \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_pass http://mobile_web/;
    }

    location /msg_gateway{
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-real-ip \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_pass http://msg_gateway/;
    }

    location ^~/api/{
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-real-ip \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header X-Request-Api \$scheme://\$host/api;
        proxy_pass http://im_api/;
    }

    location ^~/chat/{
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-real-ip \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_pass http://im_chat_api/;
    }

    location ^~/complete_admin/{
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header X-real-ip \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_pass http://im_admin_api/;
    }
}
#Redirection from HTTP to HTTPS redirection
server {
    listen 80;
    server_name ${NEW_DOMAIN};
    rewrite ^(.*)\$ https://\$host\$1 permanent;
}
EOL

# --- 执行添加操作 ---
echo "正在将 ${NEW_DOMAIN} 的服务块追加到 ${CONFIG_FILE}..."

# 为了防止脚本中的 \$ 符号被解释，在 heredoc 中使用了反斜杠转义 (\$host\$1)
# 然后将整个块追加到文件末尾
echo -e "\n${NEW_SERVER_BLOCK}" >> "$CONFIG_FILE"

echo "✅ 配置添加成功！"

# --- 检查 Nginx 配置语法并重新加载 ---
echo "正在检查 Nginx 配置语法..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx 配置语法检查通过。正在重新加载 Nginx..."
    sudo systemctl reload nginx
    echo "✅ Nginx 已重新加载。${NEW_DOMAIN} 服务块已生效。"
else
    echo "❌ Nginx 配置语法检查失败！请检查 ${CONFIG_FILE} 文件中的错误。"
fi