variable "name" {
  description = "The name of the policy"
  type = string
  default = null
}

variable "path" {
  description = "The path of the policy"
  type = string
  default = null
}

variable "description" {
  description = "The description of the policy"
  type = string
  default = null
}

variable "policy" {
  description = "The policy of the policy"
  type = string
  default = null
}

variable "tags" {
  description = "The tags of the policy"
  type = map(any)
  default = null
}