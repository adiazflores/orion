#!/bin/bash

usage() {
    echo "Usage: $0 --cluster CLUSTER_NAME --service SERVICE_NAME --task TASK_NAME DOCKER_IMAGE"
    exit 1
}

while true ; do
    case "$1" in
        -t|--task) TASK_NAME=$2 ; shift 2 ;;
        -s|--service) SERVICE_NAME=$2 ; shift 2 ;;
        -c|--cluster) CLUSTER_NAME=$2 ; shift 2 ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) break ;;
    esac
done

[ $# -eq 0 -o -z "$TASK_NAME" -o -z "$SERVICE_NAME" -o -z "$CLUSTER_NAME" ] && usage

DOCKER_IMAGE=$1
echo "Task Name":$TASK_NAME
echo "Service Name":$SERVICE_NAME
echo "Cluster Name":$CLUSTER_NAME

expr='.serviceArns[]|select(contains("/'$SERVICE_NAME'-"))|split("/")|.[2]'
SNAME=$(aws ecs list-services --output json --cluster $CLUSTER_NAME | jq -r $expr)

echo "Jq Service Name":$SNAME

OLD_TASK_DEF=$(aws ecs describe-task-definition --task-definition $TASK_NAME --output json)
NEW_TASK_DEF=$(echo $OLD_TASK_DEF | jq --arg NDI $DOCKER_IMAGE '.taskDefinition.containerDefinitions[0].image=$NDI')
FINAL_TASK=$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, executionRoleArn: "arn:aws:iam::166954342823:role/or-dev-ui-exec", taskRoleArn: .taskRoleArn, containerDefinitions: .containerDefinitions, networkMode: .networkMode, cpu: .cpu, memory: .memory, requiresCompatibilities: .requiresCompatibilities}')

aws ecs register-task-definition --family $TASK_NAME --cli-input-json "$(echo $FINAL_TASK)"
aws ecs update-service --service $SERVICE_NAME --task-definition $TASK_NAME --cluster $CLUSTER_NAME
