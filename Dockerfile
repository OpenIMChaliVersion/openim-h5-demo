# ==========================================================
# 阶段 1: 构建 (Build Stage)
# 使用 Node.js 镜像来安装依赖和运行构建命令
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

# 复制替换脚本到容器内，并赋予执行权限
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# 暴露 HTTP 端口
EXPOSE 80

# ***关键修复：将 CMD 更改为 ENTRYPOINT，以确保脚本在 Nginx 之前运行***
# ENTRYPOINT 会在容器启动时执行 entrypoint.sh 脚本
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# CMD 保持为空或设置为默认参数（如果 ENTRYPOINT 脚本需要接收参数）
CMD []
