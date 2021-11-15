variable "stack_name" {}

# Number of AZs and subnets is reduced to 1 for cost-saving purposes
variable "az_ids" {
  default = [
    "euw2-az2", # eu-west-2a
    "euw2-az3", # eu-west-2b
    "euw2-az1", # eu-west-2c
  ]
  type = list(string)
}

variable "subnet_cidrs" {
  default = {
    "private" = [
      "192.168.10.0/27",
      "192.168.10.32/27",
      "192.168.10.64/27"
    ],
    "public" = [
      "192.168.15.0/27",
      "192.168.15.32/27",
      "192.168.15.64/27"
    ]
  }
  type = map
}
