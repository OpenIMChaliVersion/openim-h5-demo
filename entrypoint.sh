# 默认替换目标
REPLACE_TARGET=""

# 1. 检查环境变量 NEW_DOMAIN 是否传入
if [ -n "$NEW_DOMAIN" ]; then
    # 情况一：用户传入了 NEW_DOMAIN 环境变量
    REPLACE_TARGET="$NEW_DOMAIN"
    echo "使用用户提供的 NEW_DOMAIN: $REPLACE_TARGET 进行替换。"
else
    # 2. 如果未传入 NEW_DOMAIN，则使用容器的 IP
    # hostname -I | awk '{print $1}' 获取容器 IP
    # 注意：在某些网络环境下（例如桥接网络），容器IP可能不是外部可访问的地址
    CONTAINER_IP=$(hostname -I | awk '{print $1}')
    REPLACE_TARGET="$CONTAINER_IP"
    echo "未检测到 NEW_DOMAIN 环境变量，使用容器 IP: $REPLACE_TARGET 进行替换。"
fi

# 确保 REPLACE_TARGET 不为空
if [ -z "$REPLACE_TARGET" ]; then
    echo "错误：无法确定替换目标（REPLACE_TARGET）！"
    exit 1
fi

echo "开始替换占位符 '$PLACEHOLDER' 为 '$REPLACE_TARGET'..."

# 由于 REPLACE_TARGET 可能会包含斜杠（例如 URL 路径），我们使用 '#' 作为 sed 的分隔符，以避免冲突。
# 示例: sed -i "s#旧字符串#新字符串#g" "$FILE"
for FILE in $TARGET_FILES; do
    echo "正在处理文件: $FILE"
    # 使用 sed 命令进行替换。-i 表示原地修改。
    # 注意：使用 # 作为分隔符，以防止 NEW_DOMAIN 或 IP 包含斜杠 / 导致 sed 语法错误。
    sed -i "s#$PLACEHOLDER#$REPLACE_TARGET#g" "$FILE"
done

echo "域名替换完成。"
echo "----------------------------------------------------"
echo "当前容器访问方式（请将此处地址替换为实际可访问的 IP/域名）:"
echo "$REPLACE_TARGET/login"
echo "----------------------------------------------------"

# 最后，使用 exec 启动 Nginx，确保 Nginx 成为容器的主进程 (PID 1)
exec nginx -g 'daemon off;'