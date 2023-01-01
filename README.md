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

### 4. Finally delete EKS cluster: 
If you have done and don't want to deploy the application, delete EKS cluster. If not, then read bellow
```
terraform destroy -auto-approve
```

### 5. Install Docker if you don't have it:
```
chmod +x docker.sh
./docker.sh
```
To use Docker without sudo, run:
```
sudo usermod -aG docker ${USER}
su - ${USER}
```

### 6. Install Jenkins from Docker

#### 1. Run Jenkins from Docker
```
docker run -u 0 -d -p 8080:8080 -p 50000:50000 -v /data/jenkins:/var/jenkins_home jenkins/jenkins:lts
```
To get the password to unlock Jenkins at the frirst launch run:
```
sudo docker exec ${CONTAINER_ID or CONTAINER_NAME} cat /var/jenkins_home/secrets/initialAdminPassword
```
where CONTAINER_ID or CONTAINER_NAME - your running container name

#### 2. Also you need the next plugins:
- CloudBees AWS credentials;
- Kubernetes Continuous Deploy (v.1.0.0), you can download [this file](https://updates.jenkins.io/download/plugins/kubernetes-cd/1.0.0/kubernetes-cd.hpi) and upload it in advanced settings in Jenkins plugin management section;
- Docker;
- Docker Pipeline;
- Amazon ECR plugin.

![plugins3](https://user-images.githubusercontent.com/51818001/142757989-6ffa7c12-98c3-4562-b3fa-962acd39ece6.png)

#### 3. Credentials settings.
Go to Jenkins -> Manage Jenkins -> Global credentials section and add AWS credentials with ID ecr

![ECR-cred](https://user-images.githubusercontent.com/51818001/141673986-8f615e47-3bf5-4748-9466-5f669bf4e481.png)

Then input the following command to get EKS config if you didn't it before in previous section:
```
aws eks update-kubeconfig --name eks --region us-east-1
```
and
```
cat /home/wave/.kube/config
```
Copy result of this command and return to Jenkins credentials section, then create Kubernetes credentials and choose Kubeconfig Enter directly

![EKS-cred](https://user-images.githubusercontent.com/51818001/141674297-d0678fe6-1622-4044-9cfb-e68cb84dd45a.png)

And input ID K8S (IMPORTANT! Field id K8S should contain all upper-case)

Also, run to get access for Jenkins to your EKS cluster
```
kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
```

#### 4. Make sure you create Maven3 variable under Global tool configuration.

![maven3](https://user-images.githubusercontent.com/51818001/141674371-a22998f4-0c63-4b0e-b928-9e581c30f14f.png)

#### 5. Create new pipeline in Jenkins and copy Jenkinsfile there.

Build your pipeline.

#### 6. Run the following command to get access from your browser:
```
kubectl get svc
```
Then copy the dns name of the load balancer. It should be something like this:
a50fec56374e843a6afbf0f96488e800-1553267577.us-east-1.elb.amazonaws.com
and add port 3000
http://a50fec56374e843a6afbf0f96488e800-1553267577.us-east-1.elb.amazonaws.com:3000

http in url is required 

#### 7. To delete the services and deployments without cluster destroying run:
```
git clone https://github.com/Kasper886/guest-book.git
cd guest-book
```
```
kubectl delete -f redis-master-controller.yaml
kubectl delete -f redis-slave-controller.yaml
kubectl delete -f guestbook-controller.yaml
```
```
kubectl delete service guestbook redis-master redis-slave
```
#### 8. To destroy EKS cluster and ECR repo run:

```
terraform destroy -auto-approve
```


## Demo

https://user-images.githubusercontent.com/51818001/142759135-cbc61a86-0b47-4d56-8394-f1b3737389b5.mp4

![screen1](https://user-images.githubusercontent.com/51818001/141676063-6bab5a63-558c-4968-9440-7f3072184b88.png)
