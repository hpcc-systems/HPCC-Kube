#!/bin/bash
################################################################################
#    HPCC SYSTEMS software Copyright (C) 2019 HPCC Systems®    .
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
################################################################################

SCRIPT_DIR=$(dirname $0)
cd ${SCRIPT_DIR}
SCRIPT_DIR=$(pwd)

source  ${SCRIPT_DIR}/../../bin/common

namespace=default
# Kubernetes quick start Install: https://istio.io/docs/setup/kubernetes/install/kubernetes/

cd ${ISTIO_HOME}

echo "Install all the Istio Custom Resource Definitions (CRDs)"
for i in install/kubernetes/helm/istio-init/files/crd*yaml
do
  ${KUBECTL} apply -f $i
done


cd ${SCRIPT_DIR}
echo "Enforce mutual TLS authentication (restric mutual TLS)"
echo "${KUBECTL} apply -f istio-demo-auth.yaml"
${KUBECTL} apply -f istio-demo-auth.yaml

echo "Verify the installation"
echo "${KUBECTL} get svc -n istio-system"
${KUBECTL} get svc -n istio-system

#echo "Label namespace as istio-injection-enabled"
echo "${KUBECTL} label namespace  ${namespace} istio-injection=enabled"
#${KUBECTL} label namespace  ${namespace} istio-injection=enabled
