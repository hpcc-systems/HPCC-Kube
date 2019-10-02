#!/bin/bash

SCRIPT_HOME=$(dirname $0)
. ${SCRIPT_HOME}/common

function usage()
{
 cat <<EOF
    Usage: $(basename $0) <options>  <action>
      <options>:
      -a: <value> admin pod. The default is hpcc-admin.
      -c: <value> component name. For example, mydali, myroxie.
      -n: <value> namespace. The default is default.
      -p: <value> Pod name.
      <action>:
         status, stop, start, restart
         For status id or ip must be provided. It can only check one node a time.

EOF
   exit 2
}

function runHPCC()
{
   [ -z "$pod_name" ] && return 1
   cmd="${KUBECTL} exec $pod_name /etc/init.d/hpcc-init"
   if [ -n "$comp_name" ]
   then
      cmd="$cmd -c $comp_name"
   fi
   cmd="$cmd $1"
   #echo "$cmd"
   eval "$cmd"
}

function runHPCCCluster()
{
   echo ""
   echo "###############################################"
   echo "#"
   echo "# $1 HPCC Cluster ..."
   echo "#"
   echo "###############################################"
   cmd="${KUBECTL} exec $admin_pod /opt/hpcc-tools/$1_hpcc.sh"
   echo "$cmd"
   eval "$cmd"

   echo ""
   echo "###############################################"
   echo "#"
   echo "# Status:"
   echo "#"
   echo "###############################################"
   ${SCRIPT_HOME}/cluster_run.sh status
}

function stxxxHPCC()
{
   if [ "$action" = "restart" ] || [ -z "$pod_name" ]
   then
       runHPCCCluster $1
       return
   fi
   runHPCC $1
}

admin_pod=hpcc-admin
namespace=default
comp_name=
pod_name=
action=

# Process command-line parameters
while getopts "*a:c:hn:p:" arg
do
   case $arg in
      a) admin_pod=${OPTARG}
         ;;
      c) comp_name=${OPTARG}
         ;;
      n) namespace=${OPTARG}
         ;;
      p) pod_name=${OPTARG}
         ;;
      h) usage
         ;;
      ?)
         echo "Unknown option $OPTARG"
         usage
         ;;
   esac
done

shift $((OPTIND -1))
action=$1

if [ -z "$action" ]
then
    echo "Missing action"
    usage
fi

case $action in
   status)
      if [ -z "$pod_name" ]
      then
         rc=0
         ${SCRIPT_HOME}/cluster_query.sh -n $namespace | \
         while read line
         do
            pod_name=$(echo $line | cut -d' ' -f1)
            echo
            echo "Status of $pod_name:"
            runHPCC status
            rc=$(expr $rc \+ $?)
         done
         exit $rc
      else
         runHPCC status
      fi
      ;;
   start)
      if [ "$comp_name" = "configmgr" ]
      then
         ${KUBECTL} exec -it $admin_pod /opt/HPCCSystems/sbin/configmgr
         exit $?
      else
         stxxxHPCC start
      fi
      ;;
   stop)
      stxxxHPCC stop
      ;;
   restart)
      stxxxHPCC stop
      stxxxHPCC start
      ;;
   ?)
      echo "Unknown action $action"
      usage
esac
