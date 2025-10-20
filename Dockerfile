# ==========================================================
# 阶段 1: 构建 (Build Stage)
# 使用 Node.js 镜像来安装依赖和运行构建命令
# ==========================================================
FROM node:18.20.8 AS builder

# 设置工作目录
WORKDIR /app

# 将 package.json 和 package-lock.json 复制到工作目录
# 这样可以利用 Docker 缓存，如果依赖未改变，则跳过 npm install
COPY package*.json ./

# 安装依赖
RUN npm install --legacy-peer-deps

# 复制所有源代码
COPY . .

# 运行构建命令，生成静态文件到 dist 目录
# 确保在构建前修改配置指向正确的 OpenIM Server API
RUN npm run build


# ==========================================================
# 阶段 2: 运行 (Production Stage)
# 使用轻量级的 Nginx 镜像来托管静态文件
# ==========================================================
FROM nginx:alpine

# 复制 Nginx 配置文件 (可选: 如果你需要自定义配置，例如设置反向代理、路由规则)
# 如果项目没有提供自定义 Nginx 配置，可以跳过或使用默认配置
#COPY nginx.conf /etc/nginx/conf.d/default.conf

# 从构建阶段复制最终的静态文件 (dist 目录的内容) 到 Nginx 的默认网页目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露 HTTP 端口
EXPOSE 80

# 启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]