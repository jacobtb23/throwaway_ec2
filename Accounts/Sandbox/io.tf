## =============== Variables ===============
variable "account_id" {
  type        = string
  description = "AWS account ID"
  default     = ""
}

variable "account_profile" {
  type        = string
  description = "Account Profile [SSO]"
  default     = "sandbox"
}

variable "region" {
  type        = string
  description = "The default AWS region."
  default     = "us-west-2"
}
