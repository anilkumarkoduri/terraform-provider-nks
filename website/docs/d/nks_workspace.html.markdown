---
layout: "nks"
page_title: "NKS : nks_workspace"
sidebar_current: "docs-nks-workspace"
description: |-
  Get information on NKS workspace
---

# nks\_workspace

The workspaces data source can be used to automatically look up your configured cloud provider workspaces, based on the API token your used in the provider.  Optionally, you can supply an organization ID as well that will be used.

## Example Usage

```hcl
data "nks_workspace" "default" {
    org_id   = 111
    name     = "Default"
}

```

## Argument Reference

 * `name` - (Optional) Search by name or part of the name of the workspace in the organization. Case insensitive.
 * `org_id` - (Optional) Organization ID to use (otherwise the default organization ID is located and used)

## Attributes Reference

 * `id` - ID of the workspace
 