# Configure the VMware vSphere Provider
provider "vsphere" {
  user = "${var.vsphere_user}"
  password = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Create a folder
resource "vsphere_folder" "Automation_Testing" {
  path = "Orchestration, Automation & CM/Automation_Testing"
  datacenter = "xLab Datacenter"
}

# Create a VM
resource "vsphere_virtual_machine" "Win10" {
  name          = "Desktop-01"
  folder        = "Orchestration, Automation & CM/Automation_Testing"
  vcpu          = 2
  memory        = 4096
  datacenter    = "xLab Datacenter"
  cluster       = "xLab Management Cluster"
  skip_customization = "false"

  network_interface {
    label              = "VM Network"
    ipv4_address       = "192.168.0.120"
    ipv4_prefix_length = "24"
    ipv4_gateway       = "192.168.0.1"
  }

  disk {
    datastore = "xLab-Synology-NFS"
    template = "VM Templates/Windows 10 Enterprise x64"
  }

  provisioner "local-exec" {
    command = "curl -X POST -H 'Content-type: application/json' -d @slack_webhook.json $SLACK_WEBHOOK"
  }

}