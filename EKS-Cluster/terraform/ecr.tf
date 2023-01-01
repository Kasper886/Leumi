resource "aws_ecr_repository" "PythonApp" {
  name                 = var.repo-name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}