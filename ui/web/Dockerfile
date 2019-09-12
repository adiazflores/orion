FROM node:11-alpine as build

WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /usr/src/app/package.json

RUN npm i -g yarn
RUN yarn install
RUN yarn add global react-scripts

RUN apk update && apk upgrade

RUN apk add --no-cache bash openssl ca-certificates
RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env

COPY . /usr/src/app
CMD ["/bin/sh", "-c", "/usr/src/app/entrypoint.sh"]

FROM nginx:alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
