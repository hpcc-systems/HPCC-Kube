#!/bin/bash

WORK_DIR=$(dirname $0)
. ${WORK_DIR}/common
${KUBECTL} create configmap hpcc-config --from-file=${WORK_DIR}/../local/configmap/hpcc/ --from-file=${WORK_DIR}/../local/configmap/hpcc/contents/
${KUBECTL} apply -f ${WORK_DIR}/../security/cluster_role.yaml
