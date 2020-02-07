################################################################################
#    HPCC SYSTEMS software Copyright (C) 2019 HPCC Systems®  .
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
<#
.SYNOPSIS
HPCC Systems Cluster Operations

.DESCRIPTION
Start configmgr

 Usage:  start_configmr.ps1 

.Example
./start_configmgr.ps1

.
.LINK
https://github.com/xwang2713/HPCC-Kubernetes

#>

param(
    $admin_pod="hpcc-admin",
    $namespace="default",
    $component="",
    $pod_name="",
    $action="status"
)

$wkDir = split-path $myInvocation.MyCommand.path

$KUBECTL = "kubectl.exe"
cd $wkDir


$cmd = "$KUBECTL exec $admin_pod -- /opt/HPCCSystems/sbin/configmgr"

"$cmd"
iex "$cmd"
