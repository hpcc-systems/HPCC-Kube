#!/bin/bash
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
