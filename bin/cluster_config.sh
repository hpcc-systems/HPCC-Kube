#!/bin/bash

SCRIPT_HOME=$(dirname $0)
. ${SCRIPT_HOME}/common


function usage()
{

 cat <<EOF
    Usage: $(basename $0) <options>
      <options>:
      -e: number of esp nodes
      -r: number of roxie node.
      -s: number of support nodes.
      -t: number of thor nodes.
      -X: do not generate environmen.xml which may be created with configmgr.
      -h: print this help

EOF
   exit 2
}

numEsp=
numRoxie=
numSupport=
numThor=
notGenEnv=0

# Process command-line parameters
while getopts "*e:hr:s:t:X" arg
do
   case $arg in
      e) numEsp=${OPTARG}
         ;;
      r) numRoxie=${OPTARG}
         ;;
      s) numSupport=${OPTARG}
         ;;
      t) numThor=${OPTARG}
         ;;
      X) notGenEnv=1
         ;;
      h) usage
         ;;
      ?)
         echo "Unknown option $OPTARG"
         usage
         ;;
   esac
done


admin_pod_id=$(${KUBECTL} get pods | grep admin | cut -d' ' -f1)

cmd="${KUBECTL} exec ${admin_pod_id} -- /opt/hpcc-tools/config_hpcc.sh"

if [ $notGenEnv -eq 0 ]
then
   [ -n "$numSupport" ] && cmd="$cmd -s $numSupport"
   [ -n "$numEsp" ] && cmd="$cmd -e $numEsp"
   [ -n "$numRoxie" ] && cmd="$cmd -r $numRoxie"
   [ -n "$numThor" ] && cmd="$cmd -t $numThor"
else
   cmd="$cmd -X"
   ${KUBECTL} exec ${admin_pod_id} -- mkdir -p /etc/HPCCSystems/cluster
   ${KUBECTL} exec ${admin_pod_id} -- cp /etc/HPCCSystems/source/environment.xml /etc/HPCCSystems/cluster/
fi
echo "$cmd"
eval $cmd
