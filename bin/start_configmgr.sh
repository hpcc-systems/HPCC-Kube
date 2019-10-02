#!/bin/bash

admin_pod=hpcc-admin
[ -n "$1" ] && admin_pod=$1
SCRIPT_HOME=$(dirname $0)
. ${SCRIPT_HOME}/common

${KUBECTL} exec ${admin_pod} /opt/HPCCSystems/sbin/configmgr
