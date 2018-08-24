#!/bin/bash -e

echo -n "AWS Access Key: "
read AWS_ACCESS_KEY_ID
export AWS_ACCESS_KEY_ID

echo -n "AWS Secret Key: "
read -s AWS_SECRET_ACCESS_KEY
echo
export AWS_SECRET_ACCESS_KEY

aws --region=eu-central-1 ec2 describe-vpcs --output=table --query 'Vpcs[*].[VpcId,CidrBlock,State]'
vpcs=( `aws --region=eu-central-1 ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output=text` )
PS3='Please enter your choice: '
select vpc in "${vpcs[@]}"
do
    case $vpc in
        "")
            echo "try again"
            ;;
        *)
            break
            ;;
    esac
done

aws --region=eu-central-1 ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --output=table --query 'Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,CidrBlock,State]'
subnets=( `aws --region=eu-central-1 ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[*].SubnetId' --output=text` )
PS3='Please enter your choice: '
select subnet in "${subnets[@]}"
do
    case $subnet in
        "")
            echo "try again"
            ;;
        *)
            break
            ;;
    esac
done

for t in */template.json; do
    docker run -it -e "AWS_ACCESS_KEY=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_KEY=${AWS_SECRET_ACCESS_KEY}" -e "VPC_ID=${vpc}" -e "SUBNET_ID=${subnet}" -v "$PWD/`dirname $t`:/template" -w /template hashicorp/packer:light build template.json
done
