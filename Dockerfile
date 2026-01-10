FROM node:20-alpine AS base

WORKDIR /app

ENV NODE_ENV=production \
    PORT=3000

# 安装构建依赖并缓存
COPY package.json package-lock.json ./
RUN npm ci

# 拷贝项目源码并构建前端资源
COPY . .
RUN npm run build

# 运行阶段：使用同一镜像，但只保留生产依赖
FROM node:20-alpine AS runtime

WORKDIR /app
ENV NODE_ENV=production \
    PORT=3000

# 仅复制 node_modules（生产依赖）和构建结果及必要源码
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/dist ./dist
COPY --from=base /app/examples ./examples
COPY --from=base /app/scripts ./scripts
COPY --from=base /app/fontfile ./fontfile
COPY --from=base /app/images ./images
COPY --from=base /app/bod ./bod
COPY package.json ./

EXPOSE 3000

# 默认启动脚本与本地开发一致
CMD ["npm", "start"]

