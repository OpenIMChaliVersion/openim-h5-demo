#!/bin/sh

# 检查 NEW_DOMAIN 环境变量是否设置，如果没有则使用默认值
if [ -z "$NEW_DOMAIN" ]; then
    echo "Warning: NEW_DOMAIN environment variable is not set. Using 'localhost' as default."
    NEW_DOMAIN="localhost"
fi

# 完整的 BASE_URL 路径
TARGET_BASE_URL="https://$NEW_DOMAIN"

# 占位符字符串，通常在您的前端代码中
PLACEHOLDER="__runtime_base_domain__"

# Nginx 静态文件的默认根目录
NGINX_ROOT=/usr/share/nginx/html

echo "Starting Nginx configuration replacement..."
echo "Replacing placeholder: $PLACEHOLDER with target: $TARGET_BASE_URL"

# 遍历 dist 目录下的所有 JS 文件，并执行替换
# 使用 'g' 标记确保所有出现都被替换
# sed -i 适用于 Alpine Linux (BusyBox) 的版本
find $NGINX_ROOT -type f -name '*.js' -exec sed -i "s|$PLACEHOLDER|$TARGET_BASE_URL|g" {} \;

# 也可以考虑替换 HTML 文件，以防变量在 <script> 标签中
# find $NGINX_ROOT -type f -name '*.html' -exec sed -i "s|$PLACEHOLDER|$TARGET_BASE_URL|g" {} \;

echo "Replacement complete. Starting Nginx..."

# 使用 exec 启动 Nginx，将 Nginx 作为容器的主进程 (PID 1)
exec nginx -g "daemon off;"