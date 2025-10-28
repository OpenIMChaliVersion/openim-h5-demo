#!/bin/sh
set -e
echo "--- ALL ENV VARS START ---"
env
echo "--- ALL ENV VARS END ---"
# 检查 NEW_DOMAIN 环境变量是否设置，如果没有则使用默认值
if [ -z "$NEW_DOMAIN" ]; then
    echo "Warning: NEW_DOMAIN environment variable is not set. Using 'localhost' as default."
    NEW_DOMAIN="localhost"
else 
    TARGET_BASE_URL="https://$NEW_DOMAIN"
    TARGET_DOMAIN=$NEW_DOMAIN
fi

# 完整的 BASE_URL 路径
TARGET_BASE_URL="https://$NEW_DOMAIN"
# Nginx 静态文件的默认根目录
NGINX_ROOT=/usr/share/nginx/html
# 占位符字符串，通常在您的前端代码中
PLACEHOLDER="__RUNTIME_BASE_DOMAIN__"

echo "--- Starting Configuration Replacement ---"
echo "Target Host: $TARGET_DOMAIN"
echo "Placeholder: $PLACEHOLDER"
echo "---"



# 2. 查找并显示所有将要被替换的文件
echo "Files to be processed:"
# 查找文件，并将其路径打印出来，方便调试
find $NGINX_ROOT -type f -name '*.js' -print


# 3. 执行替换操作
# 使用 -exec ... {} + 来一次处理多个文件，比 {} \; 更高效
find $NGINX_ROOT -type f -name '*.js' -exec sed -i "s|$PLACEHOLDER|$TARGET_DOMAIN|g" {} +

# 4. 替换后验证
echo "--- Replacement Verification ---"
# 查找是否还有未替换的占位符。如果这条命令有输出，说明替换失败。
if grep -r "$PLACEHOLDER" $NGINX_ROOT; then
    echo "ERROR: The placeholder was NOT successfully replaced! Check sed command or placeholder content."
else
    echo "SUCCESS: Placeholder replaced with $TARGET_DOMAIN in all files."
fi
echo "---"
echo "Replacement complete. Starting Nginx..."
# 使用 exec 启动 Nginx，将 Nginx 作为容器的主进程 (PID 1)
exec nginx -g "daemon off;"