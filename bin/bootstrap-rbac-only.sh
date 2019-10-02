#!/bin/bash

WORK_DIR=$(dirname $0)
. ${WORK_DIR}/common
${KUBECTL} apply -f ${WORK_DIR}/../security/cluster_role.yaml
