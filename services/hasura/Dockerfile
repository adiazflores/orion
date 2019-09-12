FROM hasura/graphql-engine:v1.0.0-beta.4
WORKDIR /usr/src/app
COPY . .
EXPOSE 80

RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env

ENTRYPOINT ["/bin/sh", "-c", "/usr/src/app/entrypoint.sh"]
