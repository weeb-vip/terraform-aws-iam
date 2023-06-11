variable "name" {
  description = "The name of the role"
  type = string
  default = null
}

variable "path" {
  description = "The path of the role"
  type = string
  default = null
}

variable "tags" {
  description = "The tags of the role"
  type = map(any)
  default = null
}

variable "assume_role_policy" {
  description = "The assume role policy of the role"
  type = string
  default = null
}

variable "policies" {
  description = "The policies of the role"
  type = list(string) # policy arn
  default = null
}
