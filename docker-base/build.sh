#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

source /etc/lsb-release

# add molindo ppa
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DAFCF825D62EB07F
#echo deb http://ppa.launchpad.net/molindo/ppa/ubuntu ${DISTRIB_CODENAME} main > /etc/apt/sources.list.d/molindo-ppa-${DISTRIB_CODENAME}.list

# add docker source
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-${DISTRIB_CODENAME} main > /etc/apt/sources.list.d/docker.list

apt-get update

# install utilities
apt-get install -y curl jshon ntp wget python-pip python-setuptools unattended-upgrades

# install awscli
pip install --upgrade awscli

# install cfn-* tools
easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

# install docker
apt-get install -y linux-image-extra-virtual linux-image-extra-$(uname -r)
apt-get install -y docker-engine

# security updates
echo "configuring security updates"
cat >> /etc/apt/apt.conf.d/20auto-upgrades <<'UPDATES'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
UPDATES

# docker config
cat > /etc/default/docker <<'DEFAULT'
DOCKER_OPTS="--storage-driver aufs -H unix:///var/run/docker.sock -g /mnt/docker"
DEFAULT

# add docker default file to systemd
mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/ubuntu.conf <<'SYSTEMD'
[Service]
# workaround to include default options
EnvironmentFile=-/etc/default/docker
ExecStart=
ExecStart=/usr/bin/docker daemon $DOCKER_OPTS
SYSTEMD

# add all users from sudo group to docker group
for user in `grep sudo /etc/group | cut -d: -f4 | sed -e 's/,/ /g'`; do
    echo "adding $user to docker group"
    usermod -aG docker $user
done

systemctl daemon-reload
systemctl restart docker.service

docker version

# script to update ec2 profile
cat > /usr/local/bin/update-ec2-env.sh <<'EC2ENV'
#!/bin/bash

region=$(ec2metadata --availability-zone | sed -e "s/.$//")
instance=$(ec2metadata --instance-id)

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
cat > /etc/systemd/system/ec2-env.service <<'SYSTEMD'
[Unit]
Description=Update EC2 profile (/etc/profile.d/01-ec2-env.sh)
After=network.target

[Service]
ExecStart=/usr/local/bin/update-ec2-env.sh

[Install]
WantedBy=multi-user.target
SYSTEMD
systemctl enable ec2-env.service

cat > /usr/local/bin/ec2-tag.sh <<'EC2TAG'
#!/bin/bash

. /etc/profile.d/01-ec2-env.sh

aws ec2 describe-tags --filters Name=resource-id,Values=$EC2_INSTANCE_ID Name=key,Values=${1-Name} --query 'Tags[0].Value' --output text
EC2TAG
chmod +x /usr/local/bin/ec2-tag.sh
