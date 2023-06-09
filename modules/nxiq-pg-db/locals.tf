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

resource "random_string" "pg_suffix" {
  length  = 12
  special = false
}

resource "random_string" "pg_user_password" {
  length  = 16
  special = false
}

locals {
  pg_database_name = "nxiq_${random_string.pg_suffix.result}"
  pg_user_username = "nxiq_${random_string.pg_suffix.result}"
  pg_user_password = random_string.pg_user_password.result
}
