#!/bin/bash
WORK_DIR=$(dirname $0)
. ${WORK_DIR}/../../../../bin/common

${KUBECTL} apply -f rbac-config-ON.yaml
${KUBECTL} apply -f tcp-access.yaml
${KUBECTL} apply -f tcp-access-bind.yaml


#${KUBECTL} apply -f internal-http-role.yaml
#${KUBECTL} apply -f internal-http-bind.yaml
