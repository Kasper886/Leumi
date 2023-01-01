#-------------------------#
# Install Docker          #
#                         #
# Created: 01.01.2022     # 
# Owner: Alex Largman     #
# Email: alex@largman.pro #
#-------------------------#

#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install -y docker-ce