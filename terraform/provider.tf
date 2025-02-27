terraform {
  required_version = ">=1.9.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.73"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_token_id
  insecure  = true
}

