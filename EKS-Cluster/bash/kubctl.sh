#-------------------------#
# Install Kube CTL        #
#                         #
# Created: 01.01.2022     # 
# Owner: Alex Largman     #
# Email: alex@largman.pro #
#-------------------------#


#!/bin/bash

#Install Kube CTL
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp ./kubectl /bin
kubectl version --short --client