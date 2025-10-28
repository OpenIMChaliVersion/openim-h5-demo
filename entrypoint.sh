# ==========================================================
# 阶段 1: 构建 (Build Stage)
# ==========================================================
FROM node:18.20.8 AS builder

# 设置工作目录
WORKDIR /app

# 将 package.json 和 package-lock.json 复制到工作目录
COPY package*.json ./

# 安装依赖
RUN npm install --legacy-peer-deps

# 复制所有源代码
COPY . .

# 运行构建命令，生成静态文件到 dist 目录
RUN npm run build


# ==========================================================
# 阶段 2: 运行 (Production Stage)
# 使用轻量级的 Nginx 镜像来托管静态文件
# ==========================================================
FROM nginx:alpine

# 复制 Nginx 配置文件 
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 从构建阶段复制最终的静态文件 (dist 目录的内容) 到 Nginx 的默认网页目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制替换脚本
COPY entrypoint.sh /usr/local/bin/

# *** 关键修复步骤：安装 dos2unix 并转换脚本格式 ***
# 这解决了 'exec format error' 错误 (Windows换行符问题)
RUN apk add --no-cache dos2unix \
    && dos2unix /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && rm -rf /var/cache/apk/*

# 暴露 HTTP 端口
EXPOSE 80

# 设置入口点，确保脚本在 Nginx 之前运行
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []