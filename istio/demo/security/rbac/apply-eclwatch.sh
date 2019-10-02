#!/bin/bash
WORK_DIR=$(dirname $0)
. ${WORK_DIR}/../../../../bin/common

${KUBECTL} apply -f eclwatch.yaml
${KUBECTL} apply -f eclwatch-bind.yaml
