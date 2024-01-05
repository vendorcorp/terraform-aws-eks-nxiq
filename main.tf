# --------------------------------------------------------------------------
#
# Copyright 2023-Present Sonatype Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# Require a minimum version of Terraform and Providers
# --------------------------------------------------------------------------
terraform {
  required_version = ">= 1.4.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.15.0"
    }
  }
}

# --------------------------------------------------------------------------
# Deploy NXIQ HA Cluster
# --------------------------------------------------------------------------
module "nxiq_pg_database" {
  source = "./modules/nxiq-pg-db"

  pg_hostname       = var.pg_hostname
  pg_port           = var.pg_port
  pg_admin_username = var.pg_admin_username
  pg_admin_password = var.pg_admin_password
}

module "nxiq_ha_cluster" {
  source = "./modules/nxiq-ha-cluster"

  default_resource_tags = var.default_resource_tags
  target_namespace      = var.target_namespace
  storage_class_name    = var.storage_class_name
  storage_volume_size   = var.storage_volume_size
  purpose               = var.purpose
  nxiq_license_file     = var.nxiq_license_file
  nxiq_version          = var.nxiq_version
  replica_count         = var.replica_count
  db_hostname           = var.pg_hostname
  db_port               = var.pg_port
  db_username           = module.nxiq_pg_database.nxiq_db_username
  db_password           = module.nxiq_pg_database.nxiq_db_password
  db_database           = module.nxiq_pg_database.nxiq_db_database
}
