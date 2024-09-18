#!/usr/bin/env bash
#set -x

IP=$(ip -br -4 addr | grep eth1 | awk '{print $3}')

cat <<EOT> /etc/netplan/50-vagrant.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth1:
      addresses:
      - $IP
      routes:
      - to: 192.168.20.0/24
        via: 192.168.10.254
EOT

chmod 600 /etc/netplan/00-installer-config.yaml
chmod 600 /etc/netplan/01-netcfg.yaml
chmod 600 /etc/netplan/50-vagrant.yaml
netplan apply
