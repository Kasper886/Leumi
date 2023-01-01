#-------------------------#
# Install Terraform       #
#                         #
# Created: 01.01.2022     # 
# Owner: Alex Largman     # 
# Email: alex@largman.pro #
#-------------------------#

#!/bin/bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y terraform