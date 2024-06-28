#!/bin/bash -e

dir=$( dirname `readlink -f $0` )
template="$dir/template.json"

region=`jq -r '.builders[0].region' $template`
current=`jq -r '.variables.source_ami' $template`

ami=`mktemp --dry-run ecs2-base-ami.XXXX`
aws --region eu-central-1 ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --query 'Parameters[].Value' --output text > $ami

image_id=`jq -r '.image_id' $ami`
image_version=`jq -r '.image_version' $ami`
image_name=`jq -r '.image_name' $ami`
ecs_agent_version=`jq -r '.ecs_agent_version' $ami`
ecs_runtime_version=`jq -r '.ecs_runtime_version' $ami`

rm $ami

if [ "$current" != "$image_id" ]; then
    echo "\"source_ami\": \"${image_id}\""
    echo ""
    echo "--- README.md ---"
    echo ""
    echo "### Source \`${image_id}\`"
    echo ""
    echo "* ECS-Optimized Amazon Linux 2 \`${image_version}\`"
    echo "* ECS container agent \`${ecs_agent_version}\`"
    echo "* ${ecs_runtime_version}"
    echo ""
    echo "#### Changelog"
    echo ""
    echo "* source only"
    echo ""
    echo "#### Regions"
    echo ""
    echo "| Region       | AMI ID                  |"
    echo "|--------------|-------------------------|"
    echo "| eu-central-1 | \`TODO\` |"
    echo "| eu-west-1    | \`TODO\` |"
    echo "| us-east-1    | \`TODO\` |"
    exit 1
else
    echo "source up to date"
    exit 0
fi
