#!/bin/bash

# Install
yum -y install jq git
yum -y install libcurl libcurl-devel ruby-devel gcc-c++

amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

curl -sL https://rpm.nodesource.com/setup_14.x | bash -
yum -y install nodejs

su ec2-user -c 'mkdir $HOME/actions-runner'
su ec2-user -c 'curl -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz -o $HOME/actions-runner/actions-runner-linux-x64-2.278.0.tar.gz'
su ec2-user -c 'tar xzf $HOME/actions-runner/actions-runner-linux-x64-2.277.1.tar.gz -C $HOME/actions-runner'

aws configure set region ap-northeast-1
export ACCESS_TOKEN=$(aws secretsmanager get-secret-value --secret-id ${your-token-id} --query SecretString --output text | jq -r .GITHUB_ACCESS_TOKEN)

# Configure
export RUNNER_TOKEN="$(curl -XPOST -fsSL \
  -H "Authorization: token ${ACCESS_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/yourorg/actions/runners/registration-token" \
| jq -r '.token')"
export RUNNER_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')

su ec2-user -c '$HOME/actions-runner/config.sh \
  --url "https://github.com/<your org>" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}"'
