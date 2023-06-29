variable "location" {
  type      = string
  default   = "eastus"
}

variable "vm_password" {
  type      = string
  sensitive = true
  default   = "Admin@123"
}

variable "vm_user" {
  type      = string
  sensitive = true
  default   = "admin"
}
