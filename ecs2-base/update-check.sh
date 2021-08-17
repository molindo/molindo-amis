#!/bin/bash -e

dir=$( dirname `readlink -f $0` )
template="$dir/template.json"

region=`jq -r '.builders[0].region' $template`
current=`jq -r '.variables.source_ami' $template`

source_ami=`aws --region eu-central-1 ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --query 'Parameters[].Value' --output text | jq -r '.image_id'`

if [ "$current" != "$source_ami" ]; then
    echo "$source_ami"
    exit 1
else
    echo "source up to date"
    exit 0
fi
