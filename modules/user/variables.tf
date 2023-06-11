variable "name" {
  description = "The name of the user"
  type = string
  default = null
}

variable "path" {
  description = "The path of the user"
  type = string
  default = null
}

variable "tags" {
  description = "The tags of the user"
  type = map(any)
  default = null
}

variable "groups" {
  description = "The groups of the user"
  type = list(string)
  default = null
}
