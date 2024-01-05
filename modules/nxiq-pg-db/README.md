## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >= 1.15.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >= 1.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | >= 1.15.0 >= 1.15.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [postgresql_database.nxiq](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/database) | resource |
| [postgresql_role.nxiq](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [random_string.pg_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.pg_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pg_admin_password"></a> [pg\_admin\_password](#input\_pg\_admin\_password) | Administrator/Root password to access your PostgreSQL service. | `string` | `null` | no |
| <a name="input_pg_admin_username"></a> [pg\_admin\_username](#input\_pg\_admin\_username) | Administrator/Root user to access your PostgreSQL service. | `string` | `null` | no |
| <a name="input_pg_hostname"></a> [pg\_hostname](#input\_pg\_hostname) | The hostname where your PostgreSQL service is accessible at. | `string` | `null` | no |
| <a name="input_pg_port"></a> [pg\_port](#input\_pg\_port) | The port where your PostgreSQL service is accessible at. | `number` | `5432` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nxiq_db_database"></a> [nxiq\_db\_database](#output\_nxiq\_db\_database) | Dedicated database for NXIQ to use to connect to PostgreSQL. |
| <a name="output_nxiq_db_password"></a> [nxiq\_db\_password](#output\_nxiq\_db\_password) | Dedicated password for NXIQ to use to connect to PostgreSQL. |
| <a name="output_nxiq_db_username"></a> [nxiq\_db\_username](#output\_nxiq\_db\_username) | Dedicated username for NXIQ to use to connect to PostgreSQL. |
