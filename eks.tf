########### Creating EKS #################
resource "aws_eks_cluster" "ekscluster" {
    name     = "${var.cluster-name}"
    role_arn = aws_iam_role.IAM.arn

    vpc_config {
       subnet_ids = "${var.subnet}"
       security_group_ids = [aws_security_group.secure.id]
    }
depends_on = [aws_iam_role_policy_attachment.Cluster-Policy]
}


############ Creating Nodes ################
resource "aws_eks_node_group" "eks-ng" {
    cluster_name    = aws_eks_cluster.ekscluster.name
    node_group_name = "task6"
    node_role_arn   = aws_iam_role.IAM.arn
    subnet_ids      = "${var.subnet}"
    instance_types  = ["t2.micro"]

    scaling_config {
     desired_size = 2
     min_size     = 1
     max_size     = 3
  }

depends_on = [aws_iam_role_policy_attachment.WorkerNodePolicy,aws_iam_role_policy_attachment.EKS_CNI_Policy,aws_iam_role_policy_attachment.EC2ContainerRegistryReadOnly]
}
