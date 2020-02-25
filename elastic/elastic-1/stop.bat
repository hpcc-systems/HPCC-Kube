rem ################################################################################
rem #    HPCC SYSTEMS software Copyright (C) 2019 HPCC Systems®    .
rem #
rem #    Licensed under the Apache License, Version 2.0 (the "License");
rem #    you may not use this file except in compliance with the License.
rem #    You may obtain a copy of the License at
rem #
rem #       http://www.apache.org/licenses/LICENSE-2.0
rem #
rem #    Unless required by applicable law or agreed to in writing, software
rem #    distributed under the License is distributed on an "AS IS" BASIS,
rem #    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem #    See the License for the specific language governing permissions and
rem #    limitations under the License.
rem ################################################################################
kubectl.exe delete -f admin.yaml
kubectl.exe delete -f support.yaml
kubectl.exe delete -f esp-e1.yaml
kubectl.exe delete -f roxie-r1.yaml
