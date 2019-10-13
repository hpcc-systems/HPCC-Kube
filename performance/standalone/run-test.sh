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
which git | grep git
if [ $? -ne 0 ]
then
apt-get update
apt-get install -y git
fi
cd /root
PERF_DIR=/root/PerformanceTesting
if [ ! -d ${PERF_DIR} ]
then
	git clone https://github.com/hpcc-systems/PerformanceTesting
fi
cd /opt/HPCCSystems/testing/regress
nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting setup -t=thor > /tmp/perf_thor.out 2>&1
nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting run -t=thor >> /tmp/perf_thor.out 2>&1 &

#nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting setup -t=roxie > /tmp/perf_roxie.out 2>&1
#nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting run -t=roxie >> /tmp/perf_roxie.out 2>&1 &

#nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting setup -t=hthor > /tmp/perf_hthor.out 2>&1
#nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting setup -t=thor >> /tmp/perf_hthor.out 2>&1
#nohup  ./ecl-test --timeout -1 --suiteDir ${PERF_DIR}/PerformanceTesting run -t=hthor >> /tmp/perf_hthor.out 2>&1 &
