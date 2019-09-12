#!/bin/bash

## This is sending memory metrics to cloudwatch. The ECS cluster can scale on this metric

echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64 
yum install -y unzip


cd /opt
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O


unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \

cd aws-scripts-mon
./mon-put-instance-data.pl --mem-util --verify --verbose

(crontab -l 2>/dev/null; echo "*/1 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-used --mem-avail --auto-scaling=only") | crontab -

# Add SSM
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm