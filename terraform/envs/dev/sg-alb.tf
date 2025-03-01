module "security_group_alb" {
  source = "../../modules/security-group"
  #basic
  project = var.project
  env     = var.env

  #security-group
  security_group = {
    name   = "alb"
    vpc_id = module.vpc.vpc_id
    ingress_rules = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        description = "Allow HTTP for all users"
        cidr_blocks = ["0.0.0.0/0"]

      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        description = "Allow HTTPs for all users"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
