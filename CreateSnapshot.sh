#!/bin/bash

region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
instanceid=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
volumeid=$(aws ec2 describe-instances \
  --region ${region} \
  --instance-id ${instanceid} \
  --query 'Reservations[].Instances[].BlockDeviceMappings[].Ebs[]' | grep vol | sed 's/^.*"\(.*\)".*$/\1/')
aws ec2 create-snapshot --region ${region} --volume-id ${volumeid} --tag-specifications 'ResourceType=snapshot,Tags={Key=AutoSnapshot,Value=true}'
