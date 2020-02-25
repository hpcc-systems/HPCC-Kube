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
Get status/start/stop  HPCC Systems Cluster

 Usage:  cluster_run.ps1 -action <status/stop/start, default is status> -namespace <namespace, default is "default">
             -component <cluster name, such as myroxie1, mydali> -pod-name <Pod name>

.Example
./cluster_run.ps1 -action status

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
function get_cluster_status()
{
  foreach ( $pod in (./cluster_query.ps1))
  {
      kubectl.exe exec $pod /etc/init.d/hpcc-init status
      ""
  }
}

function runHPCC ($a)
{
    if ( "$pod_name" -eq "" )
    {
        return 1
    }
   $cmd = "${KUBECTL} exec $pod_name /etc/init.d/hpcc-init"
   if  ( $comp_name )
   {
      $cmd = "$cmd -c $comp_name"
   }
   $cmd = "$cmd $a"
   "$cmd"
   iex "$cmd"

}

function runHPCCCluster ( $a )
{

   $cmd = "${KUBECTL} exec $admin_pod /opt/hpcc-tools/${a}_hpcc.sh"
   "$cmd"
   iex "$cmd"


    get_cluster_status
}

function stxxHPCC ($a)
{
   if ( $action -ieq "restart" -or  ! $pod_name )
   {
       runHPCCCluster $a
       return
   }
   runHPCC $a
}



switch ( $action )
{
   "status"
   {
       if (! $pod_name)
       {
          get_cluster_status
       }
       else
       {
           runHPCC $action
       }

   }
   "start"
   {
       if ( $component -ieq "configmgr")
       {
          kubectl.exe exec -it $admin_pod /opt/HPCCSystems/sbin/configmgr
       }
       else
       {
           stxxHPCC "start"
       }
   }
   "stop"
   {
       stxxHPCC "stop"
   }
   "restart"
    {
        stxxHPCC "stop"
        stxxHPCC "start"
    }
    "*"
    {
        "Unknown action $action"
    }
}
