variable "env" {
  type        = string
  description = "must be true or false"
  default     = ""

  validation {
    condition     = can(regex("^(Prod|Blue)$", var.env))
    error_message = "Must be Prod or Dev environment - Please update enviroment name in variable file and try again..!"
  }
}