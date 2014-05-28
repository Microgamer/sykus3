#!/bin/bash 

if [ "`whoami`" != "root" ]; then 
  sudo $0
  exit
fi

apt-get -y install \
  vim git-core \
  build-essential ruby-dev libxml2-dev xvnc4viewer \
  ruby2.0 ruby2.0-dev p7zip-full genisoimage qemu-kvm libvirt-bin ruby-switch

ruby-switch --set ruby2.0

gem install --no-rdoc --no-ri ruby-vnc net-ssh net-sftp thor

echo "If this is the initial KVM install you MUST reboot."

