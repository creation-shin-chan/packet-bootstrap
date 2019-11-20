resource "packet_device" "kube-master" {
  hostname         = "kube-master"
  plan             = "c2.large.arm"
  facilities         = ["${var.DC}"] # Data center
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"
}

resource "packet_device" "kube-worker-1" {
  hostname         = "kube-worker-1"
  plan             = "m1.xlarge.x86"
  facilities         = ["${var.DC}"]
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"
}

resource "packet_device" "kube-worker-2" {
  hostname         = "kube-worker-2"
  plan             = "m1.xlarge.x86"
  facilities         = ["${var.DC}"] 
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"
}

resource "packet_device" "kube-worker-3" {
  hostname         = "kube-worker-3"
  plan             = "m1.xlarge.x86"
  facilities         = ["${var.DC}"] 
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"
}