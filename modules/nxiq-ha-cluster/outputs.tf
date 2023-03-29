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

output "nxiq_ha_k8s_namespace" {
  value = local.namespace
}

output "nxiq_ha_k8s_service_id" {
  value = kubernetes_service.nxiq.id
}

output "nxiq_ha_k8s_service_name" {
  value = "nxiq-ha-${var.nxiq_name}-svc"
}
