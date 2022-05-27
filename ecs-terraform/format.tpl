#!/bin/bash
sudo mkdir -p /root/first
sudo mkdir -p /root/second
sudo yum install -y ecs-init aws-cfn-bootstrap
sudo yum update -y ecs-init
sudo yum install -y lvm2 awscli
sudo pvcreate /dev/xvdf /dev/xvdg
sudo vgcreate first /dev/xvdf
sudo vgcreate second /dev/xvdg
sudo lvcreate -n vol -l 100%FREE first
sudo lvcreate -n vol -l 100%FREE second
sudo mkfs.ext4 /dev/first/vol
sudo mkfs.ext4 /dev/second/vol
sudo echo "/dev/first/vol /root/first ext4 defaults 0 0" >> /etc/fstab
sudo echo "/dev/second/vol /root/second ext4 defaults 0 0" >> /etc/fstab
sudo mount -a
sudo echo ECS_CLUSTER=${CLUSTER} >> /etc/ecs/ecs.config
sudo echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
