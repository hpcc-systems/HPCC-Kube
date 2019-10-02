#!/bin/bash

SCRIPT_HOME=$(dirname $0)
. ${SCRIPT_HOME}/common

function usage()
{
 cat <<EOF
    Push environment.xml from admin node /etc/HPCCSystems/source/ to cluster nodes
    The environment.xml need to be transfered to /etc/HPCCSystems/source/ on admin node before transfer to to the cluster.
    Usage: $(basename $0) <options>
      <options>:
      -a: admin Pod name. The default is hpcc-admin
      -d: a directory contain environment.xml.xml in admin node
      -D: a directory contain environment.xml.xml in local host

EOF
   exit 2
}

admin_pod=hpcc-admin
nodeDir=
hostDir=

# Process command-line parameters
while getopts "*a:d:D:h" arg
do
   case $arg in
      a) admin_pod=${OPTARG}
         ;;
      d) nodeDir=${OPTARG}
         ;;
      D) comp=${OPTARG}
         ;;
      h) usage
         ;;
      ?)
         echo "Unknown option $OPTARG"
         usage
         ;;
   esac
done


if [ -n "$hostDir" ]
then
   env_file=${hostDir}/environment.xml
   if [ ! -e "${env_file}" ]
   then
      echo "${env_file} doesn't exist"
      exit 1
   fi
   ${KUBECTL} cp ${env_file} ${admin_pod}:/etc/HPCCSystems/source/
   if [ $? -ne 0 ]
   then
       echo "Failed to copy environment.xml from local $hostDir to /etc/HPCCSystems/source/ on Pod ${admin_pod}"
       exit 1
   fi
elif [ -n "$nodeDir" ]
then
   env_file=${nodeDir}/environment.xml
   ${KUBECTL} exec ${admin_pod} cp $env_file /etc/HPCCSystems/source/
   if [ $? -ne 0 ]
   then
       echo "Failed to copy environment.xml from $nodeDir to /etc/HPCCSystems/source/"
       exit 1
   fi
fi

${KUBECTL} exec ${admin_pod} /opt/hpcc-tools/stop_hpcc.sh
${KUBECTL} exec ${admin_pod} /opt/hpcc-tools/push_env.sh
${KUBECTL} exec ${admin_pod} /opt/hpcc-tools/start_hpcc.sh
