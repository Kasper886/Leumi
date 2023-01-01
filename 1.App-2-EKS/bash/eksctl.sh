#-------------------------#
# Install EKS CTL         #
#                         #
# Created: 01.01.2022     # 
# Owner: Alex Largman     # 
# Email: alex@largman.pro #
#-------------------------#

#!/bin/bash
#Install EKS CTL
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /bin
eksctl version