variable "proxmox_endpoint" {
  type        = string
  description = "The endpoint for the proxmox API (http://your-proxmox-url:8006)"
}

variable "proxmox_token_id" {
  type        = string
  description = "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  sensitive   = true
}

variable "ansible_path" {
  type        = string
  description = "you ansible path"
}

