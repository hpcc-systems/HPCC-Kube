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

function usage() {
  echo "${0} [-s|-t|-z]"
  echo "  Create AWS EBS volume"
  echo "  -s: volume size in GB ."
  echo "  -t: volume type. The defauilt is gp2"
  echo "  -z: available zone."
  echo ""
}


available_zone=
volume_size=
volume_type=gp2

while getopts "s:t:z:h" opt; do
  case ${opt} in
    s)
      volume_size="$OPTARG";;
    t)
      volume_type="$OPTARG";;
    z)
      availability_zone="$OPTARG";;
    h)
      usage
      exit 0;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1;;
  esac
done
shift $((OPTIND-1))

if [ -z "$availability_zone" ]; then
  echo "Missing availability zone"
  usage
  exit 1
fi

if [ -z "$volume_size" ]; then
  echo "Missing volume size"
  usage
  exit 1
fi

aws ec2 create-volume --availability-zone $availability_zone \
  --size $volume_size --volume-type $volume_type | grep  "VolumeId" | \
  cut -d':' -f2 |  sed 's/[[:space:]][[:space:]]*\"\(.*\)\",/\1/'

# "VolumeId": "vol-233c99fe",
