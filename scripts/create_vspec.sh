#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2026 JASPAR
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

THIS_SCRIPT_FILE_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
THIS_SCRIPT_DIR_PATH="$(dirname "$THIS_SCRIPT_FILE_PATH")"
REPOSITORY_ROOT_DIR_PATH="$(dirname "$THIS_SCRIPT_DIR_PATH")"
VSPEC_ROOT_FILE_PATH=${REPOSITORY_ROOT_DIR_PATH}/external/vehicle_signal_specification/spec/VehicleSignalSpecification.vspec
OVERLAY_DIR_PATH="${REPOSITORY_ROOT_DIR_PATH}/vss/vehicle"
TYPE_DIR_PATH="${REPOSITORY_ROOT_DIR_PATH}/vss/types"
ARTIFACT_DIR_PATH="${REPOSITORY_ROOT_DIR_PATH}/artifact"
YORIITO_VSS_JSON_PATH="${ARTIFACT_DIR_PATH}/yoriito_vss.json"
YORIITO_VSS_CSV_PATH="${ARTIFACT_DIR_PATH}/yoriito_vss.csv"
YORIITO_VSS_TREE_PATH="${ARTIFACT_DIR_PATH}/yoriito_vss.tree"
YORIITO_VSS_YAML_PATH="${ARTIFACT_DIR_PATH}/yoriito_vss.yaml"

VSS_COMMAND="vspec"
function setup_vss_tools {
  if command -v vspec >/dev/null 2>&1; then
    return
  fi
  if command -v pipx >/dev/null 2>&1; then
    VSS_COMMAND="pipx run vss-tools==6.0"
    return
  fi

  echo "vss-tools is not installed. Please install it like the following."
  echo "  python3 -m pip install vss-tools==6.0"
  echo
  echo "If you use python3.12+, you will need to setup venv before installing it like the following."
  echo "  python3 -m venv ."
  echo "  source ./bin/activate"
  echo "  pip install -e . "
  echo
  echo "Or, you can avoid this problem by installing pipx like the following."
  echo "  sudo apt install pipx"
  exit 1
}

echo "STEP1. Install VSS Tools"
setup_vss_tools

echo "STEP2: Fetch COVESA VSPEC repository"
git submodule update --init

echo "STEP3: Overlay COVESA VSPEC with Yoriito VSPEC and generate json, csv, and tree files"
# Need to specify the order of overlaying.
# Temporarily, overlay files with shallower paths first.
OVERLAY_OPTION=$(find "$OVERLAY_DIR_PATH" -name "*.vspec" |  awk '{ print length, $0 }' | sort -n | cut -d' ' -f2- | sed 's/^/-l /')
TYPES_VSPEC=${TYPE_DIR_PATH}/types.vspec

${VSS_COMMAND} export json --vspec ${VSPEC_ROOT_FILE_PATH} --output ${YORIITO_VSS_JSON_PATH} ${OVERLAY_OPTION} --types ${TYPES_VSPEC}
${VSS_COMMAND} export csv --vspec ${VSPEC_ROOT_FILE_PATH} --output ${YORIITO_VSS_CSV_PATH} ${OVERLAY_OPTION} --types ${TYPES_VSPEC}
${VSS_COMMAND} export tree --vspec ${VSPEC_ROOT_FILE_PATH} --output ${YORIITO_VSS_TREE_PATH} ${OVERLAY_OPTION} --types ${TYPES_VSPEC}
${VSS_COMMAND} export yaml --vspec ${VSPEC_ROOT_FILE_PATH} --output ${YORIITO_VSS_YAML_PATH} ${OVERLAY_OPTION} --types ${TYPES_VSPEC}

echo "Done."
