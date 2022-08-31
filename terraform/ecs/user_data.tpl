#!/bin/bash
# Update all packages
sudo yum update -y
sudo amazon-linux-extras disable docker
sudo amazon-linux-extras install -y ecs
sudo systemctl enable --now ecs
#Adding cluster name in ecs config
echo ECS_CLUSTER="cluster-demo" >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
