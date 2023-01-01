# IAM for nodes group
resource "aws_iam_role" "nodes_general" {
  name               = "eks-node-group"
  assume_role_policy = "${file("nodes_policy.json")}"
}

# IAM for nodes group
resource "aws_iam_role_policy_attachment" "worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" 
  role       = aws_iam_role.nodes_general.name                     
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_general.name                
}

resource "aws_iam_role_policy_attachment" "registry_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_general.name 
}

resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes-01"               

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.nodes_general.arn

  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME 
  subnet_ids = [aws_subnet.private.0.id, aws_subnet.private.1.id]

  # Configuration block with scaling settings
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type             = var.ami_type
  capacity_type        = var.capacity_type      
  disk_size            = var.disk_size           
  force_update_version = false       
  instance_types       = ["${var.instance_types}"]

  labels = {
    role = "nodes-general"
  }
  version = "1.21" # Kubernetes version

  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.eks_cni,
    aws_iam_role_policy_attachment.registry_read,
  ]
}