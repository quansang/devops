# Create ECR
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project}-${var.env}-${var.ecr.name}-ecr-repository"
  image_tag_mutability = var.ecr.image_tag_mutability
  force_delete         = var.ecr.force_delete

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.ecr.name}-ecr-repository"
  }
}
