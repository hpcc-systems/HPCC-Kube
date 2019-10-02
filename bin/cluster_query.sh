#!/bin/bash
                                                                                                                                             SCRIPT_HOME=$(dirname $0)

. ${SCRIPT_HOME}/common


function usage()
{

 cat <<EOF
    Usage: $(basename $0) <options>
      <options>:
      -n <value>: namespace. The default is default
      -p <value>: Pod prefix (for query pod name) or name (for query ip). For example dali, roxie-r1, esp, etc
      -q: <value> : ${query_usage}

EOF
   exit 2
}

function getPodNames()
{
  cmd="${KUBECTL} get pods -n ${namespace} | grep -i \"${pod}\" | cut -d' ' -f1"
  QUERY_RESULT=$(eval $cmd)
}


function getIpByPodName()
{
  # to do. May not be needed
  QUERY_RESULT=
}

query_usage="name (default), ip"

query=name
namespace=default
pod="^dali\\|^esp\\|^roxie\\|^thor\\|^support\\|^eclcc\\|^dropzone\\|^backup\\|^sasha\\|^scheduler"
ip=
QUERY_RESULT=

# Process command-line parameters
while getopts "*hn:p:q:" arg
do
   case $arg in
      n) namespace=${OPTARG}
         ;;
      p) pod=${OPTARG}
         ;;
      q) query=${OPTARG}
         ;;
      h) usage
         ;;
      ?)
         echo "Unknown option $OPTARG"
         usage
         ;;
   esac
done

# Perform query
case $query in
   name)
      getPodNames
      ;;
   ip)
      getIpByPodName
      ;;
   ?)
      echo "Unknown query type"
      echo "Validated input for \"-q\":  ${query_usage}"
      exit 2
esac

if [ -n "$QUERY_RESULT" ]
then
    echo "$QUERY_RESULT"
fi

exit
