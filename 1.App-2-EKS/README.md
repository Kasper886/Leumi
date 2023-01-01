# AWS EKS cluster creation by Terraform and application deployment
This repo demonstrates how to create AWS EKS cluster by means of IaaC Terraform and assign network resources to it. Below you can find the diagram that illustrates created cluster.

![Image alt](https://github.com/Kasper886/WaveProject/blob/master/EKS-Cluster/files/diagram3.png)

## Summary
### Network
1. Dedicated VPC
2. 2 public subnets in 2 availability zones A and B
3. 2 private subnets in 2 availability zones A and B
4. Internet gateway for Future use
5. 2 NAT gateways in 2 availability zones A and B to get access for private instances for Future use
6. Route Tables
7. Route Table Association

### Nodes
1. Worker nodes in private subnets
2. Scaling configuration - desired size = 2, max size = 10, min_size = 1
3. Instances type - spot instances t3.small

### IAM Role & Policies
1. Cluster Role - Let EKS permission to create/use aws resources by cluster.
2. Policy - [Cluster_Policy](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy)
3. Node Group Role - Let EC2 permission to create/use aws resources by instances.
4. Policy - [Worker_Node](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSWorkerNodePolicy)
5. Policy - [EKS_CNI](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKS_CNI_Policy)
6. Policy - [Registry_Read](https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEC2ContainerRegistryReadOnly)

## How to do
You should have terraform on board and AWS credentials to get access to your AWS account.

### 1. Clone repository and start the Terraform script
```
git clone https://github.com/Kasper886/Leumi.git
```
```
cd Leumi/1.App-2-EKS/
```
Install Terraform if you don't have it.<br/>
If your user is not a root user, ask your admin to add user to sudoers:
```
sudo visudo
```
Then install Terraform
```
chmod +x bash/terraform.sh
bash/terraform.sh
```
If you want to scale your node group, you need:
1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
2. [EKSCTL](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
3. [KubeCTL](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

To install the tools above, follow the next steps:
```
chmod +x bash/awscli.sh
chmod +x bash/eksctl.sh
chmod +x bash/kubectl.sh
```
```
bash/awscli.sh
```
```
bash/eksctl.sh
```
```
bash/kubectl.sh
```

### 2. So, you can launch EKS cluster now:
Export AWS credentials and your default region (I worked in us-east-1 region)
```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-east-1
```
```
terraform init
```
```
terraform plan
```
```
terraform apply -auto-approve
```

### 3. Work with EKS cluster
When the cluster is created you can run the following command to "login" to your EKS cluster:

aws eks update-kubeconfig --name clusterName --region AWS region

  Where the clusterName is the name of your cluster (eks), AWS region is the region of AWS (us-east-1)
```
aws eks update-kubeconfig --name eks --region us-east-1
```

Then make scaling:

eksctl scale nodegroup --cluster=clusterName --nodes=4 --name=nodegroupName

  Where clusterName is name of your cluster (wave-eks), nodegroupName - name of your group name (nodes-01)
```
eksctl scale nodegroup --cluster=eks --nodes=4 --name=nodes-01
```

### 4. Finally delete EKS cluster
If you have done and don't want to deploy the application, delete EKS cluster. If not, go to [the next section](https://github.com/Kasper886/WaveProject/tree/master/App)
```
terraform destroy -auto-approve
```

## Demo

https://user-images.githubusercontent.com/51818001/139727318-5aeb08dd-3e20-45d3-a59d-a0e4a39e98ac.mp4
