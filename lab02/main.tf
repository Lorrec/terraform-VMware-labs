provider "vsphere" {
  user           = "gabe@vsphere.local"
  password       = "P@ssw0rd01"
  vsphere_server = "192.168.169.11"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "East"
  datacenter_id = data.vsphere_datacenter.dc.id

}

data "vsphere_datastore" "datastore" {
  name          = "380SSDDatastore2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "GHM"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 20
  }
}

output "server_name" {
  value = vsphere_virtual_machine.vm.name
}

output "server_memory" {
  value = vsphere_virtual_machine.vm.memory
}
