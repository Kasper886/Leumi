#-------------------------#
# Install AWS CLI         #
#                         #
# Created: 01.01.2022     # 
# Owner: Alex Largman     #
# Email: alex@largman.pro #
#-------------------------#


#!/bin/bash
#Install AWS CLI
sudo apt install -y zip unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
aws --version