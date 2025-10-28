#!/bin/sh
# 定义 Web 应用的静态文件根目录
WEB_ROOT="/usr/share/nginx/html"
PLACEHOLDER="__RUNTIME_BASE_DOMAIN__"
TARGET_FILES=$(find $WEB_ROOT/assets -name "*.js")

# 检查环境变量是否传入
if [ -n "$NEW_DOMAIN" ]; then
  # 情况一：用户传入了 NEW_DOMAIN 环境变量
  REPLACE_TARGET="$NEW_DOMAIN"
  echo "Using provided NEW_DOMAIN: $REPLACE_TARGET"
else

CONTAINER_IP=$(hostname -I | awk '{print $1}')
REPLACE_TARGET="$CONTAINER_IP"

fi

echo "Replacing placeholder '$PLACEHOLDER' with '$REPLACE_TARGET' in JS files..."
for FILE in $TARGET_FILES; do
    echo "Processing file: $FILE"
    # 使用 sed 命令进行替换：
    # s/旧字符串/新字符串/g：全局替换
    # 注意：使用 | 作为分隔符，并确保 $REPLACE_TARGET 中不含 | 
    sed -i "s|$PLACEHOLDER|$REPLACE_TARGET|g" "$FILE"
done

echo "Domain replacement complete. Starting Nginx..."
echo "当前访问方式"
echo "$PLACEHOLDER/login"
exec nginx -g 'daemon off;'