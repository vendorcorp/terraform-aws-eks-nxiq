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
  required_version = ">= 1.0.11"
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
    name = local.namespace
    annotations = {
      "nxiq_purpose" = "${var.nxiq_name}"
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s Secrets
# --------------------------------------------------------------------------
resource "kubernetes_secret" "nxiq" {
  metadata {
    name      = "nxiq-secrets"
    namespace = local.namespace
    annotations = {
      "nxiq_purpose" = "${var.nxiq_name}"
    }
  }

  binary_data = {
    "license.lic" = filebase64("${var.nxiq_license_file}")
  }

  data = {
    "db_password" = var.db_password
  }

  type = "Opaque"
}

# --------------------------------------------------------------------------
# Create k8s PVC
# --------------------------------------------------------------------------
resource "kubernetes_persistent_volume_claim" "nxiq" {
  metadata {
    name      = "nxiq-pvc"
    namespace = var.target_namespace
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "efs-fs"
    resources {
      requests = {
        storage = "25Gi"
      }
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s Deployment
# --------------------------------------------------------------------------
resource "kubernetes_deployment" "nxiq" {
  metadata {
    name      = "nxiq-ha-${var.nxiq_name}"
    namespace = local.namespace
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
        node_selector = {
          instancegroup = "shared"
        }

        init_container {
          name    = "chown-nexusdata-owner-to-nexus-and-init-log-dir"
          image   = "busybox:1.33.1"
          command = ["/bin/sh"]
          args = [
            "-c",
            ">- chown -R '1000:1000' /sonatype-work"
          ]
        }

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

          # env {
          #   name  = "NEXUS_SECURITY_RANDOMPASSWORD"
          #   value = false
          # }

          # env {
          #   name  = "INSTALL4J_ADD_VM_PARAMS"
          #   value = "-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Dnexus.licenseFile=/nxrm3-secrets/license.lic -Dnexus.datastore.enabled=true -Djava.util.prefs.userRoot=$${NEXUS_DATA}/javaprefs -Dnexus.datastore.nexus.jdbcUrl=jdbc:postgresql://$${DB_HOST}:$${DB_PORT}/$${DB_NAME} -Dnexus.datastore.nexus.username=$${DB_USER} -Dnexus.datastore.nexus.password=$${DB_PASSWORD} -Dnexus.datastore.clustered.enabled=true"
          # }

          port {
            container_port = 8070
          }

          security_context {
            run_as_user = 1000
          }

          volume_mount {
            mount_path = "/nxiq-secrets"
            name       = "nxiq-secrets"
          }

          volume_mount {
            mount_path = "/sonatype-work"
            name       = "nxiq-data"
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
            claim_name = "nxiq-data"
          }
        }
      }
    }
  }
}

# --------------------------------------------------------------------------
# Create k8s Service
# --------------------------------------------------------------------------
resource "kubernetes_service" "nxiq" {
  metadata {
    name      = "nxiq-ha-${var.nxrm_name}-svc"
    namespace = local.namespace
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
