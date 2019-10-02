#!/bin/bash

WORK_DIR=$(dirname $0)
. ${WORK_DIR}/common
${KUBECTL} create configmap hpcc-config --from-file=${WORK_DIR}/../aws/configmap/hpcc/
${KUBECTL} apply -f ${WORK_DIR}/../security/cluster_role.yaml
