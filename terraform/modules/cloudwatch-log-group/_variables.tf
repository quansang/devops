#modules/cloudwatch-log-group/_variables.tf
#cloudwatch-log-group
variable "name" {
  description = "CloudWatch log group name"
  type        = string
}
variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
}
