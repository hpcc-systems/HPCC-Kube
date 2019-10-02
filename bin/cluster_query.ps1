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
