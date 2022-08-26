variable "region" {
  default="us-east-1"
}
## Keeping empty means it will prompt and ask for value
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}