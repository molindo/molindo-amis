#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

source /etc/lsb-release

apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-${DISTRIB_CODENAME} main > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y linux-image-extra-virtual
apt-get install -y docker-engine

cat > /etc/default/docker <<DEFAULT
DOCKER_OPTS="--storage-driver aufs -H unix:///var/run/docker.sock -g /mnt/docker"
DEFAULT

## add default file to systemd
mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/ubuntu.conf <<SYSTEMD
[Service]
# workaround to include default options
EnvironmentFile=-/etc/default/docker
ExecStart=
ExecStart=/usr/bin/docker daemon \$DOCKER_OPTS
SYSTEMD

systemctl daemon-reload

# add all users from sudo group to docker group
for user in `grep sudo /etc/group | cut -d: -f4 | sed -e 's/,/ /g'`; do
    echo "adding $user to docker group"
    usermod -aG docker $user
done
