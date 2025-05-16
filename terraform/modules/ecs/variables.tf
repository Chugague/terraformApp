variable "cluster_name" {}
variable "task_family" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "container_name" {}
variable "image" {}
variable "container_port" {}
variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "service_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "desired_count" {
  default = 1
}
variable "target_group_arn" {}
