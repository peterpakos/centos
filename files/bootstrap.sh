#!/bin/bash

groupadd docker && usermod -aG docker vagrant

cp -r /vagrant/files/.ssh ~vagrant/
chown -R vagrant:vagrant ~vagrant/.ssh
chmod 700 ~vagrant/.ssh && chmod 600 ~vagrant/.ssh/*

for i in rpcbind nfslock iptables ip6tables; do
  service $i stop; chkconfig $i off
done

yum -y install http://epel.check-update.co.uk/6/i386/epel-release-6-8.noarch.rpm
yum -y update
yum -y install htop nmap bash-completion
yum -y remove postfix
yum -y install --enablerepo=epel-testing docker-io

sed -i 's/other_args=/other_args="-s btrfs"/' /etc/sysconfig/docker
cp /vagrant/files/90-nproc.conf /etc/security/limits.d/

cd /vagrant/files
wget -N -nv https://get.docker.com/builds/Linux/x86_64/docker-latest
cp /vagrant/files/docker-latest /usr/bin/docker
chmod +x /usr/bin/docker

chkconfig docker on && service docker start
