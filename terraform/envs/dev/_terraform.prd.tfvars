project     = "project"
env         = "prd"
branch_name = "master"
repo_name = {
  app = "quansang/devops"
}
region        = "us-east-1"
account_id    = "xxx"
elb_region_id = "127311923021"
domain        = "youops.io.vn"
vpc = {
  cidr          = "10.0.0.0/16"
  public_cidrs  = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  private_cidrs = ["10.0.12.0/22", "10.0.16.0/22", "10.0.20.0/22"]
}
ecs = {
  app = {
    desired_count  = 0
    container_port = 3000
    host_port      = 3000
    task_memory    = 512
    task_cpu       = 256
    total_memory   = 512
    total_cpu      = 256
  }
}
