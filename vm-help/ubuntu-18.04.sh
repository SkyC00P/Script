#!/bin/bash

_ip=${1:-192.168.1.105}

# 0. 设置 root 密码
echo 1. set root passwd
sudo passwd

# 1. config network
echo 2. set config network
(
cat << EOF
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens33:
            dhcp4: no
            dhcp6: no
            addresses: [${_ip}/24,]
            gateway4:  192.168.1.1
            nameservers:
              addresses: [202.96.128.166, 202.96.134.133]
            optional: true
    version: 2
EOF
) > net.yaml
test -f net.yaml && sudo cp -rfd net.yaml /etc/netplan/50-cloud-init.yaml
sudo netplan apply

# 2. 挂载共享目录以及配置环境变量
echo 3. set share dir and /etc/profile
test -e ${HOME}/shares || mkdir ${HOME}/shares
cp -rfd /etc/profile profile
(
cat << EOF
/usr/bin/vmhgfs-fuse .host:/ ${HOME}/shares -o subtype=vmhgfs-fuse,allow_other 2>> /tmp/err.log
source H_Global_Function.sh 2>> /tmp/err.log
EOF
) >> profile
sudo mv profile /etc/profile
test -e /tmp/H_Global_Function.sh && sudo mv /tmp/H_Global_Function.sh /usr/bin
sudo sed -i "s/#user_allow_other/user_allow_other/g" /etc/fuse.conf;

# 3. 更新源
echo 4. update and upgrade
sudo apt-get update && sudo apt-get upgrade

