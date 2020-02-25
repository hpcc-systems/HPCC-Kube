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
Query HPCC Systems Cluster Pods

.DESCRIPTION
This is top Poswershell script to query HPCC Systems Cluster Pods

 Usage:  cluster_query.ps1 -namespace <namespace, default is "default"> -pattern <Pod name pattern>

.Example
./cluster_query.ps1

.NOTES

.LINK
https://github.com/xwang2713/HPCC-Kubernetes

#>

param(
    $namespace="default",
    $pod=""
)

#$KUBECTL="kubectl.exe"
$pod_pattern='^esp|^support|^roxie|^thor|^eclcc|^dropzone|^backup|^sasha|^scheduler'
if ( $pod )
{
   $pod_pattern=$pod_prefix
}


Function get_pod_names
{

  #(kubectl.exe get pods -n ${namespace} | select-string -pattern  "${pod_pattern}" | out-string).trim().split(' ')[0]
  foreach ( $line in (kubectl.exe get pods -n ${namespace} | select-string -pattern  "${pod_pattern}" ))
  {
      ($line | out-string).trim().split(' ')[0]
  }

}


get_pod_names
