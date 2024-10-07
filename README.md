# Terraform Module: Sonatype IQ Server

This repository contains a Terraform Module that will deploy an Active-Active Cluster of Sonatype IQ Server.

It has some pre-requisites:
- You have already got a PostgreSQL service available, know where it is and have ADMIN access to it
- You have a valid Sonatype license file for Sonatype IQ Server (Lifecycle of Firewall)

An exmaple using this module can be found in [tools-nxiq-ha-cluster](https://github.com/vendorcorp/tools-nxiq-ha-cluster).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.19.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >= 1.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.19.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nxiq_pg_database"></a> [nxiq\_pg\_database](#module\_nxiq\_pg\_database) | git::ssh://git@github.com/vendorcorp/terraform-aws-rds-database.git | v0.1.1 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.nxiq](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.nxiq](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_namespace.nxiq](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_persistent_volume_claim.nxiq](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource |
| [kubernetes_secret.nxiq](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.nxiq-admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.nxiq-app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.pg_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_name_prefix"></a> [database\_name\_prefix](#input\_database\_name\_prefix) | Prefix for the PostgreSQL database name. | `string` | `"nxiq"` | no |
| <a name="input_default_resource_tags"></a> [default\_resource\_tags](#input\_default\_resource\_tags) | List of tags to apply to all resources created in AWS | `map(string)` | `{}` | no |
| <a name="input_nxiq_license_data"></a> [nxiq\_license\_data](#input\_nxiq\_license\_data) | Sonatype License data for IQ Server (base64 encoded). | `string` | n/a | yes |
| <a name="input_nxiq_version"></a> [nxiq\_version](#input\_nxiq\_version) | Version of NXIQ to deploy. | `string` | `"1.171.0"` | no |
| <a name="input_pg_admin_password"></a> [pg\_admin\_password](#input\_pg\_admin\_password) | Administrator/Root password to access your PostgreSQL service. | `string` | `null` | no |
| <a name="input_pg_admin_username"></a> [pg\_admin\_username](#input\_pg\_admin\_username) | Administrator/Root user to access your PostgreSQL service. | `string` | `null` | no |
| <a name="input_pg_hostname"></a> [pg\_hostname](#input\_pg\_hostname) | The hostname where your PostgreSQL service is accessible at. | `string` | `null` | no |
| <a name="input_pg_port"></a> [pg\_port](#input\_pg\_port) | The port where your PostgreSQL service is accessible at. | `string` | `null` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Helpful description of the purpose / use for this Sonatype IQ Server | `string` | n/a | yes |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of replicas to run in the Active-Active NXIQ HA Cluster. | `number` | `1` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Storage Class to use for PVs - must support 'ReadWriteMany' mode. | `string` | `null` | no |
| <a name="input_storage_volume_size"></a> [storage\_volume\_size](#input\_storage\_volume\_size) | Size of the PV for Sonatype IQ Server | `string` | `"5Gi"` | no |
| <a name="input_target_namespace"></a> [target\_namespace](#input\_target\_namespace) | Namespace in which to deploy Sonatype IQ Server | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nxiq_ha_admin_service_id"></a> [nxiq\_ha\_admin\_service\_id](#output\_nxiq\_ha\_admin\_service\_id) | n/a |
| <a name="output_nxiq_ha_admin_service_name"></a> [nxiq\_ha\_admin\_service\_name](#output\_nxiq\_ha\_admin\_service\_name) | n/a |
| <a name="output_nxiq_ha_service_id"></a> [nxiq\_ha\_service\_id](#output\_nxiq\_ha\_service\_id) | n/a |
| <a name="output_nxiq_ha_service_name"></a> [nxiq\_ha\_service\_name](#output\_nxiq\_ha\_service\_name) | n/a |
| <a name="output_nxiq_identifier"></a> [nxiq\_identifier](#output\_nxiq\_identifier) | n/a |


# The Fine Print

At the time of writing I work for Sonatype, and it is worth nothing that this is **NOT SUPPORTED** bu Sonatype - it is purely a contribution to the open source community (read: you!).

Remember:
- Use this contribution at the risk tolerance that you have
- Do NOT file Sonatype support tickets related to cheque support in regard to this project
- DO file issues here on GitHub, so that the community can pitch in