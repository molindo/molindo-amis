#!/bin/bash -e

yum install -y curl aws-cli aws-cfn-bootstrap amazon-cloudwatch-agent amazon-efs-utils nvme-cli vim bash-completion

# enable amazon-cloudwatch-agent, exits gracefully if no config in
# a) /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
# b) /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d
systemctl enable amazon-cloudwatch-agent.service

# enable amazon-ssm-agent, exits gracefully if unable to connect
systemctl enable amazon-ssm-agent.service

cat >> /etc/ecs/ecs.config <<'ECS_CONFIG'
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","syslog","awslogs"]
ECS_ENABLE_CONTAINER_METADATA=true
ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
ECS_CONFIG

# script to update ec2 profile
cat > /usr/local/bin/update-ec2-env.sh <<'EC2ENV'
#!/bin/bash

region=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone | egrep -o '^[a-z]+-[a-z]+-[0-9]')
instance=$(curl http://169.254.169.254/latest/meta-data/instance-id)
vpc=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/`cat /sys/class/net/eth0/address`/vpc-id)

cat > /etc/profile.d/01-ec2-env.sh <<ENV
# this file is auto-generated, don't edit!

# path
export PATH="/opt/aws/bin:$PATH"

# globals
export EC2_REGION=$region
export EC2_INSTANCE_ID=$instance
export EC2_VPC_ID=$vpc

# aws cli
export AWS_DEFAULT_REGION=$region

ENV
EC2ENV
chmod +x /usr/local/bin/update-ec2-env.sh

# profile placeholder
echo '# ec2-env not updated yet!' > /etc/profile.d/01-ec2-env.sh

# systemd unit to update ec2 profile on startup
cat > /etc/systemd/system/multi-user.target.wants/ec2-env.service <<'SYSTEMD'
[Unit]
Description=Update EC2 profile (/etc/profile.d/01-ec2-env.sh)
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-ec2-env.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SYSTEMD

# script to update ec2 IP
cat > /usr/local/bin/update-ec2-ip.sh <<'EC2IP'
#!/bin/bash -e

. /etc/profile.d/01-ec2-env.sh

cluster=`/usr/local/bin/ec2-tag.sh Cluster`

## update ECS config (ECS is started after cloud-init)
echo "ECS_CLUSTER=${cluster}" >> /etc/ecs/ecs.config

# assign Elastic IP
allocations=`/usr/local/bin/ec2-tag.sh ip-allocations`
for allocation in ${allocations}; do
    echo "trying to associate elastic IP with allocationId ${allocation} to instance ${EC2_INSTANCE_ID}"
    association=`aws --region $EC2_REGION ec2 associate-address --instance-id ${EC2_INSTANCE_ID} --allocation-id ${allocation} --no-allow-reassociation --query AssociationId --output text || true`
    if [ -n "$association" ]; then
        echo "associated ${allocation} with ${instance}: $association"
        echo "export EC2_ELASTIC_IP=${allocation}" >> /etc/profile.d/01-ec2-env.sh
        echo "ECS_INSTANCE_ATTRIBUTES={\"molindo.elastic-ip\": \"true\"}" >> /etc/ecs/ecs.config
        break
    fi
done

EC2IP
chmod +x /usr/local/bin/update-ec2-ip.sh

# systemd unit to update EC2 IP on startup
cat > /etc/systemd/system/multi-user.target.wants/ec2-ip.service <<'SYSTEMD'
[Unit]
Description=Update EC2 IP
After=ec2-env.service
Before=ecs.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-ec2-ip.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SYSTEMD

# script to signal success
cat > /usr/local/bin/ec2-signal.sh <<'EC2SIGNAL'
#!/bin/bash -e

. /etc/profile.d/01-ec2-env.sh

autoscaling=`/usr/local/bin/ec2-tag.sh aws:autoscaling:groupName`
stack=`/usr/local/bin/ec2-tag.sh aws:cloudformation:stack-name`
resource=`/usr/local/bin/ec2-tag.sh aws:cloudformation:logical-id`

signal=1
for attempt in {1..60}; do
    echo "accessing ECS agent metadata #${attempt}"
    if [ "`curl -sI -XGET http://localhost:51678/v1/metadata | grep '200 OK'`" ]; then
        signal=0
        break
    else
        sleep 1
    fi
done

if [ ! "$autoscaling" ]; then
    echo "not an autoscaling instance"
elif [ $signal -ne 0 ]; then
    echo "setting auto scaling instance to unhealthy"
    aws autoscaling set-instance-health --instance-id $EC2_INSTANCE_ID --health-status "Unhealthy"
fi

if [ $stack ] && [ $resource ]; then
    echo "sending signal ($EC2_REGION/$stack/$resource=$signal)"
    cfn-signal -e $signal --region $EC2_REGION --stack $stack --resource $resource || true
fi

EC2SIGNAL
chmod +x /usr/local/bin/ec2-signal.sh

# systemd unit to signal EC2 AutoScaling success on startup
cat > /etc/systemd/system/multi-user.target.wants/ec2-signal.service <<'SYSTEMD'
[Unit]
Description=EC2 AutoScaling Signal
After=ecs.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ec2-signal.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SYSTEMD

cat > /usr/local/bin/ec2-tag.sh <<'EC2TAG'
#!/bin/bash -e

: ${1:?"Usage: $0 TAG"}

. /etc/profile.d/01-ec2-env.sh

aws ec2 describe-tags --filters Name=resource-id,Values=$EC2_INSTANCE_ID Name=key,Values=${1} --query 'Tags[].Value' --output text
EC2TAG
chmod +x /usr/local/bin/ec2-tag.sh

cat > /usr/local/bin/ec2-instances.sh <<'EC2INSTANCES'
#!/bin/bash -e

. /etc/profile.d/01-ec2-env.sh

aws ec2 describe-instances --filters Name=vpc-id,Values=$EC2_VPC_ID Name=instance-state-name,Values=running --output table \
  --query "sort_by(Reservations[].Instances[].{InstanceId: InstanceId, Ip: PrivateIpAddress, Group: Tags[?Key == 'aws:autoscaling:groupName'].Value | [0], Zone: Placement.AvailabilityZone, Type: InstanceType}, &Group)"
EC2INSTANCES
chmod +x /usr/local/bin/ec2-instances.sh

cat > /usr/local/bin/ephemeral-fstab.sh <<'EPHFSTAB'
#!/bin/bash -e

function usage() {
    echo "$1 not set"
    echo "usage: $0 [dirPrefix] [fs] [opts]"
}

dirPrefix=${1:-/mnt/ephemeral}
fs=${2:-ext4}
opts=${3:-defaults,nofail,noatime 0 2}

n=0
for nvme in `nvme list | grep 'Amazon EC2 NVMe Instance Storage' | grep -o '^/dev/nvme[0-9]n1' | sort`; do
    dir=${dirPrefix}${n}
    mkdir -p ${dir}
    blkid ${nvme} || mkfs.${fs} ${nvme}
    grep --silent "$nvme" /etc/fstab || echo "${nvme} ${dir} ${fs} ${opts}" >> /etc/fstab
    n=$((n+1))
done

EPHFSTAB
chmod +x /usr/local/bin/ephemeral-fstab.sh

cat > /usr/local/bin/ebs-fstab.sh <<'EBSFSTAB'
#!/bin/bash -e

function usage() {
    echo "$1 not set"
    echo "usage: $0 dev dir [fs] [opts]"
}

dev=${1?`usage dev`}
dir=${2?`usage dir`}
fs=${3:-auto}
opts=${4:-defaults,nofail,noatime 0 2}

nvme=`readlink -f ${dev}`

mkdir -p ${dir}
grep --silent "$nvme" /etc/fstab || echo "${nvme} ${dir} ${fs} ${opts}" >> /etc/fstab

EBSFSTAB
chmod +x /usr/local/bin/ebs-fstab.sh

cat > /usr/local/bin/efs-fstab.sh <<'EFSFSTAB'
#!/bin/bash -e

function usage() {
    echo "$1 not set"
    echo "usage: $0 efs dir"
}

efs=${1?`usage efs`}
dir=${2?`usage dir`}

mkdir -p ${dir}
grep --silent "$efs" /etc/fstab || echo "${efs}:/ ${dir} efs tls,_netdev" >> /etc/fstab

EFSFSTAB
chmod +x /usr/local/bin/efs-fstab.sh
