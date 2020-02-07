#!/bin/bash
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
