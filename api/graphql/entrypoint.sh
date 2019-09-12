#!/bin/sh
export AWS_ENV_PATH=$AWS_ENV_PATH
export AWS_REGION=$AWS_REGION
env
eval $(AWS_ENV_PATH=$AWS_ENV_PATH AWS_REGION=$AWS_REGION aws-env)

if [ "$NODE_ENV" == "development" ]
then
    yarn dev
else
    yarn start
fi
