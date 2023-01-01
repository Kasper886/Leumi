# IAM role for EKS
resource "aws_iam_role" "eks_cluster" {
  name               = "eks-cluster" # The name of the role
  assume_role_policy = "${file("cluster_policy.json")}"
}


# IAM role for EKS
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" 
  role       = aws_iam_role.eks_cluster.name
}


# EKS cluster 
resource "aws_eks_cluster" "eks" {
  name     = "eks"                        
  role_arn = aws_iam_role.eks_cluster.arn 
  version  = "1.21"                       
  vpc_config {
    endpoint_private_access = false 
    endpoint_public_access  = true  
    # Subnets in 2 AZ
    subnet_ids = [aws_subnet.private.0.id,
                  aws_subnet.private.1.id,
                  aws_subnet.public.0.id, 
                  aws_subnet.public.1.id]
      
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}