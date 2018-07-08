---
layout: "stackpoint"
page_title: "StackPoint: stackpoint_solution"
sidebar_current: "docs-stackpoint-resource-solution"
description: |-
  Installs and manages a solution in a cluster
---

# stackpoint\_solution

Installs and manages a solution in a cluster in StackPointCloud's system

## Example Usage

```hcl
resource "stackpoint_solution" "jenkins" {
  org_id               = "${data.stackpoint_keysets.keyset_default.org_id}"
  cluster_id           = "${stackpoint_cluster.terraform-cluster.id}"
  solution             = "jenkins"
  config               = "${file("solutions/jenkins.json")}"
}
```

## Argument reference

* `org_id` - (Required)[int] Organization ID, usually populated by a reference to a keyset datasource value
* `cluster_id` - (Required)[int] Cluster ID, usually populated by a reference to a cluster resource value
* `solution` - (Required)[string] Solution name
* `config` - (Optional)[file] Config file for solutions that require JSON configuration file
