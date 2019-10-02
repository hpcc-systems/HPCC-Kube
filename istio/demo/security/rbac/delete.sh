#!/bin/bash
WORK_DIR=$(dirname $0)
. ${WORK_DIR}/../../../../bin/common

#${KUBECTL} delete -f internal-http-bind.yaml
#${KUBECTL} delete -f internal-http-role.yaml
${KUBECTL} delete -f tcp-access-bind.yaml
${KUBECTL} delete -f tcp-access.yaml

${KUBECTL} delete -f rbac-config-ON.yaml
