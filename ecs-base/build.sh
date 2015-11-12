#!/bin/bash -e

yum install -y curl aws-cli

# replace docker TODO make version check dynamic
docker version
version="1.7.1"
newVersion="1.9.0"
if [ `echo $version | cut -d. -f1` -le 1 -a `echo $version | cut -d. -f2` -le 8 ]; then
    curl "https://get.docker.com/builds/Linux/x86_64/docker-$newVersion" > /tmp/docker
    chmod +x /tmp/docker
    echo "replacing docker $version with $newVersion"
    exec=`which docker`
    mv $exec $exec-dist
    mv /tmp/docker $exec
fi
/etc/init.d/docker restart
docker version

# uncomment once amazon-ecs-agent allows awslogs driver (#251)
#cat >> /etc/ecs/ecs.config <<'ECS_CONFIG'
#ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","syslog","awslogs"]
#ECS_CONFIG

# script to update ec2 profile
cat > /usr/local/bin/update-ec2-env.sh <<'EC2ENV'
#!/bin/bash

region=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone | egrep -o '^[a-z]+-[a-z]+-[0-9]')
instance=$(curl http://169.254.169.254/latest/meta-data/instance-id)

cat > /etc/profile.d/01-ec2-env.sh <<ENV
# this file is auto-generated, don't edit!

# globals
export EC2_REGION=$region
export EC2_INSTANCE_ID=$instance

# aws cli
export AWS_DEFAULT_REGION=$region

ENV
EC2ENV
chmod +x /usr/local/bin/update-ec2-env.sh

# profile placeholder
echo '# ec2-env not updated yet!' > /etc/profile.d/01-ec2-env.sh

# systemd unit to update ec2 profile on startup
cat > /etc/init/ec2-env.conf <<'UPSTART'
description "Update EC2 profile (/etc/profile.d/01-ec2-env.sh)"

start on started elastic-network-interfaces

script
    /usr/local/bin/update-ec2-env.sh
end script
UPSTART

cat > /usr/local/bin/ec2-tag.sh <<'EC2TAG'
#!/bin/bash -e

: ${1:?"Usage: $0 TAG"}

. /etc/profile.d/01-ec2-env.sh

aws ec2 describe-tags --filters Name=resource-id,Values=$EC2_INSTANCE_ID Name=key,Values=${1} --query 'Tags[0].Value' --output text
EC2TAG
chmod +x /usr/local/bin/ec2-tag.sh
