#!/bin/sh
set -e

# --- 1. 定义配置和路径 ---

# 域名配置（如果您的项目有）
DOMAIN_PLACEHOLDER='__BASE_DOMAIN_PLACEHOLDER__'
DYNAMIC_DOMAIN="$BASE_DOMAIN" 

# 图像列表配置
LIST_PLACEHOLDER='__INIT_AVATAR_LIST_PLACEHOLDER__'
CONFIG_FILE="/etc/config/avatar_urls.txt" 

# 查找所有需要替换的静态文件 (JS 和 HTML)
JS_FILES=$(find /usr/share/nginx/html -type f -name "*.js" -o -name "*.html")

echo "Starting container entrypoint script..."

# --- 2. 替换配置域名（可选，如果需要） ---
if [ ! -z "$DYNAMIC_DOMAIN" ]; then
    echo "Replacing DOMAIN placeholder with: $DYNAMIC_DOMAIN"
    for FILE in $JS_FILES; do
        sed -i "s|${DOMAIN_PLACEHOLDER}|${DYNAMIC_DOMAIN}|g" "$FILE"
    done
fi


# --- 3. 替换 URL 列表（主要需求） ---
if [ -f "$CONFIG_FILE" ]; then
    echo "Found custom URL list file: $CONFIG_FILE"
    
    # 读取文件内容，并移除换行符，准备进行替换
    URL_LIST_CONTENT=$(cat "$CONFIG_FILE" | tr -d '\n' | tr -d '\r')

    for FILE in $JS_FILES; do
        echo "Replacing URL list placeholder in $FILE."
        
        # 使用 Perl 进行替换 (处理复杂字符串)
        # 确保您的 Dockerfile 包含 RUN apk add --no-cache perl
        perl -pi -e "s{${LIST_PLACEHOLDER}}{${URL_LIST_CONTENT}}g" "$FILE"
        
    done
    
else
    echo "Warning: Custom URL list file $CONFIG_FILE not found. Using compiled placeholder."
fi

# --- 4. 执行容器主命令 ---
echo "Executing main container command: $@"
exec "$@"