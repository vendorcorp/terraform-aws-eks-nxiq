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
  }
}

# --------------------------------------------------------------------------
# Create k8s Namespace
# --------------------------------------------------------------------------
resource "kubernetes_namespace" "nxiq" {
  metadata {
    name = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s Secrets
# --------------------------------------------------------------------------
resource "kubernetes_secret" "nxiq" {
  metadata {
    name      = "nxiq-secrets"
    namespace = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
  }

  binary_data = {
    "license.lic" = filebase64("${var.nxiq_license_file}")
  }

  data = {
    "psql_password" = var.db_password
  }

  type = "Opaque"
}

# --------------------------------------------------------------------------
# Create k8s PVC
# --------------------------------------------------------------------------
resource "kubernetes_persistent_volume_claim" "nxiq" {
  metadata {
    generate_name = "nxiq-data-pvc"
    namespace     = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = var.storage_volume_size
      }
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s ConfigMap for config.yml
# --------------------------------------------------------------------------
resource "kubernetes_config_map" "nxiq" {
  metadata {
    generate_name = "nxiq-configuration-"
    namespace     = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
  }

  data = {
    "config.yml" = "${file("${path.module}/config.yml")}"
  }
}

# --------------------------------------------------------------------------
# Create k8s Deployment
# --------------------------------------------------------------------------
resource "kubernetes_deployment" "nxiq" {
  metadata {
    name      = "nxiq-ha"
    namespace     = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
    labels = {
      app = "nxiq-ha"
    }
  }
  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "nxiq-ha"
      }
    }

    template {
      metadata {
        labels = {
          app = "nxiq-ha"
        }
      }

      spec {
        container {
          image             = "sonatype/nexus-iq-server:${var.nxiq_version}"
          name              = "nxiq-app"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "NXIQ_DATABASE_HOSTNAME"
            value = var.db_hostname
          }

          env {
            name  = "NXIQ_DATABASE_NAME"
            value = var.db_database
          }

          env {
            name = "NXIQ_DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "nxiq-secrets"
                key  = "db_password"
              }
            }
          }

          env {
            name  = "NXIQ_DATABASE_PORT"
            value = var.db_port
          }

          env {
            name  = "NXIQ_DATABASE_USERNAME"
            value = var.db_username
          }

          port {
            name           = "app"
            container_port = 8070
          }

          port {
            name           = "admin"
            container_port = 8071
          }

          security_context {
            run_as_user = 1000
          }

          volume_mount {
            mount_path = "/nxiq-secrets"
            name       = "nxiq-secrets"
          }

          volume_mount {
            mount_path = "/sonatype-work/clm-cluster"
            name       = "nxiq-data"
          }

          volume_mount {
            mount_path = "/etc/nexus-iq-server"
            name       = "nxiq-config"
          }
        }

        volume {
          name = "nxiq-secrets"
          secret {
            secret_name = "nxiq-secrets"
          }
        }

        volume {
          name = "nxiq-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nxiq.metadata[0].name
          }
        }

        volume {
          name = "nxiq-config"
          config_map {
            name = kubernetes_config_map.nxiq.metadata[0].name
            items {
              key  = "config.yml"
              path = "config.yml"
            }
          }
        }
      }
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s Service
# --------------------------------------------------------------------------
resource "kubernetes_service" "nxiq-app" {
  metadata {
    name      = "nxiq-ui-svc"
    namespace     = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
    labels = {
      app = "nxiq-ha"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.nxiq.metadata.0.labels.app
    }

    port {
      name        = "http"
      port        = 8070
      target_port = 8070
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "nxiq-admin" {
  metadata {
    name      = "nxiq-admin-svc"
    namespace     = var.target_namespace
    annotations = {
      "com.sonatype.iq/cluster-id" = local.identifier
      "com.sonatype.iq/purpose" = var.purpose
    }
    labels = {
      app = "nxiq-ha"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.nxiq.metadata.0.labels.app
    }

    port {
      name        = "http"
      port        = 8071
      target_port = 8071
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}
