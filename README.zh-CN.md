

- **Chrome**：推荐使用最新版本以获得最佳体验。

## 快速开始

按照以下步骤设置本地开发环境：

1. 拉取代码

   ```bash
   git clone https://github.com/openimsdk/openim-h5-demo.git
   cd openim-h5-demo
   ```

2. 安装依赖

   ```bash
   npm install
   ```

3. 修改配置

   - `config/dev.env.ts` 和 `config/pord.env.ts`

     > 如果没有修改过服务端默认端口，则只需要修改`BASE_HOST`为您的服务器 ip 即可，如需配置域名和 https 访问，可以参考[nginx 配置](https://docs.openim.io/zh-Hans/guides/gettingStarted/nginxDomainConfig)，并采用最下方的配置项，并修改`BASE_DOMAIN`为您的域名。

     ```javascript
     const BASE_HOST = 'your-server-ip'
     const CHAT_URL = `http://${BASE_HOST}:10008`
     const API_URL = `http://${BASE_HOST}:10002`
     const WS_URL = `ws://${BASE_HOST}:10001`

     // const BASE_DOMAIN = 'your-server-domain'
     // const CHAT_URL = `http://${BASE_DOMAIN}/chat`
     // const API_URL = `http://${BASE_DOMAIN}/api`
     // const WS_URL = `ws://${BASE_DOMAIN}/msg_gateway`
     ```

4. 运行 `npm run dev` 来启动开发服务器。访问 [http://localhost:3003](http://localhost:3003) 查看结果。默认情况下将同时启动 Electron 应用程序。

5. 开始开发测试！ 🎉

## 音视频通话

开源版支持一对一音视频通话，并且需要先部署并配置[服务端](https://github.com/openimsdk/chat/blob/main/HOW_TO_SETUP_LIVEKIT_SERVER.md)。多人音视频通话、视频会议请联系邮箱 [contact@openim.io](mailto:contact@openim.io)

### 注意

- 如果要在 web 端进行音视频通话，只能在本地（localhost）进行调试，或者部署到 https 站点上后使用，这是因为浏览器的安全策略限制。

## 构建 🚀

> 该项目允许分别构建 Web 应用程序和 Electron 应用程序，但在构建过程中会有一些差异。

### Web 应用程序

1. 运行以下命令来构建 Web 应用程序：
   ```bash
   npm run build
   ```
2. 构建结果将位于 `dist` 目录。

## 常见问题

1. 发布 web 端时，wasm 加载太慢如何解决？ 不建议使用，

   答：针对 wasm 文件采用 gzip 压缩，压缩后会大大减小体积。同时可以做 cdn 加速，加快加载速度。

2. 制作docker 镜像

   答：
   a. 创建Dockerfile
   b. 制作images 文件
```
 docker build -t openim-h5-demo:latest .
```
   c. 运行验证  文件
```
docker run -d -p 8111:80 --name openim-h5-app openim-h5-demo:latest
```
```
 docker run -d --name openim-admin-front -p 11002:80 --network openim-docker_openim openim/openim-admin-front:latest

docker run -d --name openim-mobile-front -p 11003:80 --network openim-docker_openim openim-h5-demo:latest
```