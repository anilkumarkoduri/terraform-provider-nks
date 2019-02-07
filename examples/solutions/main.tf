provider "nks" {
  # Set environment variable NKS_API_TOKEN with your API token from NKS
  # Set environment variable NKS_API_URL with API endpoint,   
  # defaults to NKS production enviroment.
}

# Organization
data "nks_organization" "default" {
  name = "${var.organization_name}"
}

# Keyset
data "nks_keyset" "keyset_default" {
  # You can specify a custom orgID here or the system will find and use your
  # default organization ID.
  org_id   = "${data.nks_organization.default.id}"
  name     = "${var.provider_keyset_name}"
  category = "provider"
  entity   = "${var.provider_code}"
}

data "nks_keyset" "keyset_ssh" {
  # You can specify a custom orgID here or the system will find and use your
  # default organization ID.
  org_id   = "${data.nks_organization.default.id}"
  category = "user_ssh"
  name     = "${var.ssh_keyset_name}"
}

# Instance specs
data "nks_instance_specs" "master-specs" {
  provider_code = "${var.provider_code}"
  node_size     = "${var.provider_master_size}"
}

data "nks_instance_specs" "worker-specs" {
  provider_code = "${var.provider_code}"
  node_size     = "${var.provider_worker_size}"
}

# Cluster
resource "nks_cluster" "terraform-cluster" {
  org_id                            = "${data.nks_organization.default.id}"
  cluster_name                      = "${var.cluster_name}"
  provider_code                     = "${var.provider_code}"
  provider_keyset                   = "${data.nks_keyset.keyset_default.id}"
  region                            = "${var.provider_region}"
  k8s_version                       = "${var.provider_k8s_version}"
  startup_master_size               = "${data.nks_instance_specs.master-specs.node_size}"
  startup_worker_count              = 2
  startup_worker_size               = "${data.nks_instance_specs.worker-specs.node_size}"
  provider_resource_group_requested = "${var.provider_resource_group}"
  rbac_enabled                      = true
  dashboard_enabled                 = true
  etcd_type                         = "${var.provider_etcd_type}"
  platform                          = "${var.provider_platform}"
  channel                           = "${var.provider_channel}"
  ssh_keyset                        = "${data.nks_keyset.keyset_ssh.id}"
}

resource "nks_solution" "efk" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "efk"
}

resource "nks_solution" "haproxy" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "haproxy"
}

resource "nks_solution" "istio" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "istio"
}

resource "nks_solution" "jenkins" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "jenkins"
  config     = "${file("solutions/jenkins.json")}"
}

resource "nks_solution" "linkerd" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "linkerd"
}

resource "nks_solution" "prometheus" {
  org_id     = "${data.nks_organization.default.id}"
  cluster_id = "${nks_cluster.terraform-cluster.id}"
  solution   = "prometheus"
}
