variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}
variable "branch_name" {
  description = "Name of branch"
  type        = string
}
variable "repo_name" {
  description = "Name of repositories"
  type        = any
}
variable "region" {
  description = "Region of environment"
  type        = string
}
variable "account_id" {
  description = "Account ID of project environment"
  type        = string
}
variable "elb_region_id" {
  description = "ELB Account ID of region"
  type        = string
}
variable "domain" {
  description = "Domain of project environment"
  type        = string
}
variable "ecs" {
  description = "Spectifications of all services using AWS ECS"
  type        = any
}
