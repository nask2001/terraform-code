variable "instance_type" {
  type    = string
  description = "The size of the EC2 Instance"
}
variable "NoofInstance" {
  type = number
  description = "The number of EC2 Instance"
}

variable "ami_id" {
    type = string

    validation {
    condition = (
        length(var.ami_id) > 4 &&
        substr(var.ami_id, 0, 4) == "ami-"
    )
    error_message = "The ami_id value must start with \"ami-\"."
    }
}
