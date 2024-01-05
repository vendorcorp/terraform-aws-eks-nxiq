## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.19.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_database"></a> [db\_database](#input\_db\_database) | Name of the Database inside PostgreSQL to use. | `string` | `null` | no |
| <a name="input_db_hostname"></a> [db\_hostname](#input\_db\_hostname) | The hostname where your PostgreSQL service is accessible at. | `string` | `null` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password for NXIQ to use to access PostgreSQL service. | `string` | `null` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | The port where your PostgreSQL service is accessible at. | `number` | `5432` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Username for NXIQ to use to access PostgreSQL service. | `string` | `null` | no |
| <a name="input_default_resource_tags"></a> [default\_resource\_tags](#input\_default\_resource\_tags) | List of tags to apply to all resources created in AWS | `map(string)` | `{}` | no |
| <a name="input_nxiq_license_file"></a> [nxiq\_license\_file](#input\_nxiq\_license\_file) | Path to a valid Sonatype License file for Nexus Repository Manager Pro. | `string` | n/a | yes |
| <a name="input_nxiq_version"></a> [nxiq\_version](#input\_nxiq\_version) | Version of NXIQ to deploy. | `string` | `"1.158.0"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Helpful description of the purpose / use for this Sonatype IQ Server | `string` | n/a | yes |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of replicas to run in the Active-Active NXIQ HA Cluster. | `number` | `1` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Storage Class to use for PVs - must support 'ReadWriteMany' mode. | `string` | `null` | no |
| <a name="input_storage_volume_size"></a> [storage\_volume\_size](#input\_storage\_volume\_size) | Size of the PV for Sonatype IQ Server | `string` | `"25Gi"` | no |
| <a name="input_target_namespace"></a> [target\_namespace](#input\_target\_namespace) | Namespace in which to deploy Sonatype IQ Server | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nxiq_ha_k8s_admin_service_id"></a> [nxiq\_ha\_k8s\_admin\_service\_id](#output\_nxiq\_ha\_k8s\_admin\_service\_id) | n/a |
| <a name="output_nxiq_ha_k8s_admin_service_name"></a> [nxiq\_ha\_k8s\_admin\_service\_name](#output\_nxiq\_ha\_k8s\_admin\_service\_name) | n/a |
| <a name="output_nxiq_ha_k8s_service_id"></a> [nxiq\_ha\_k8s\_service\_id](#output\_nxiq\_ha\_k8s\_service\_id) | n/a |
| <a name="output_nxiq_ha_k8s_service_name"></a> [nxiq\_ha\_k8s\_service\_name](#output\_nxiq\_ha\_k8s\_service\_name) | n/a |
| <a name="output_nxiq_identifier"></a> [nxiq\_identifier](#output\_nxiq\_identifier) | n/a |
