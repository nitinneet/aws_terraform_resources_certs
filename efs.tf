################ Creating EFS ####################
resource "aws_efs_file_system" "example" {
  creation_token = "${var.cluster-name}-example"

  tags = {
    Name = "${var.cluster-name}-example"
  }
}

############## Mount the Volume ####################
resource "aws_efs_mount_target" "example" {
  count = 2
  file_system_id = aws_efs_file_system.example.id
  subnet_id = "${var.subnet-name}"
  security_groups = [aws_security_group.secure.id]
}


# After the EKS cluster is created I had to manually install the EFS CSI driver into the cluster before continuing.
# Then in the k8s/ directory I reference the aws/ state file so I can use the EFS file system IDs in the PV creation.
/*
data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = "example-s3-terraform"
    key    = "aws-provider.tfstate"
    region = "us-east-1"
  }
}


resource "kubernetes_persistent_volume" "example" {
  metadata {
    name = "example-efs-pv"
  }
  spec {
    storage_class_name = "efs-sc"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      nfs {
        path = "/"
        server = data.terraform_remote_state.remote.outputs.efs_example_fsid
      }
    }
  }
}

*/
