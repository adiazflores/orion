FROM node:11-alpine
WORKDIR /usr/src/app
COPY . .
RUN yarn install && yarn build

RUN apk update && apk upgrade && \
  apk add --no-cache openssl ca-certificates

RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env

EXPOSE 80
CMD ["/bin/sh", "-c", "/usr/src/app/entrypoint.sh"]
