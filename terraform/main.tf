terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

resource "digitalocean_droplet" "jenkis" {
  image    = "ubuntu-22-04-x64"
  name     = var.jenkins_vm_name
  region   = var.region
  size     = var.vm_specs
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = var.vm_specs
    node_count = 1
  }
}

variable "ssh_key_name" {
  default = ""
}

variable "jenkins_vm_name" {
  default = ""
}

variable "do_token" {
  default = ""
}

variable "region" {
  default = ""
}

variable "vm_specs" {
  default = ""
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkis.ipv4_address
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kube_config.yaml"
}