#!/bin/bash
WORK_DIR=$(dirname $0)
. ${WORK_DIR}/../../../../bin/common

${KUBECTL} delete -f eclwatch.yaml
${KUBECTL} delete -f eclwatch-bind.yaml
