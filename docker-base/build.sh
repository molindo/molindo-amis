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
apt-get install -y curl jshon ntp wget python-pip unattended-upgrades

# install awscli
pip install --upgrade awscli

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
