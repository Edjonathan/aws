#!/bin/bash
# Update all packages
yum update -y
amazon-linux-extras disable docker
amazon-linux-extras install -y ecs
systemctl enable --now --no-block ecs.service
#Adding cluster name in ecs config
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=cluster-demo
ECS_ENABLE_TASK_IAM_ROLE=true
EOF
