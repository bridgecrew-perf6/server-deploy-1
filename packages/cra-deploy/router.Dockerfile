FROM node:14-alpine as builder

WORKDIR /code

# 单独分离 package.json, 是为了 yarn 可以最大限度利用缓存
ADD package.json yarn.lock /code/

RUN yarn 

# 单独分离 public/src， 是为了避免 ADD . /code时候， 因为 README/Nginx.conf 的更改避免缓存生效
# 也是为了 npm run build 可以最大限度利用缓存
ADD . /code
RUN npm run build

# 选择更小体积的基础镜像
FROM nginx:alpine
ADD nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder code/build /usr/share/nginx/html