#    Copyright 2020 Leonardo Andres Morales

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#!/bin/bash

### Validate defined variables ###
# usage: validateVars <var1> <var2> ... <varN>
function validateVars() {
    local _result=0
    for var in ${@}; do
        if [ -z "${!var}" ]; then
            echoError "Environment varirable '${var}' is not declared!" >&2
            ((_result+=1))
        fi
    done
    return ${_result}
}

### dependencies verification ###
# usage: verifyDeps <dep1> <dep2> ... <depN>
function verifyDeps() {
    local _result=0
    for dep in ${@}; do
        which ${dep} &> /dev/null
        if [[ $? -ne 0 ]]; then
            echoError "Binary dependency '${dep}' not found!" >&2
            ((_result+=1))
        fi
    done
    return ${_result}
}

### Check if a value exists in an array ###
# usage: valueInArray <value> <array>
function valueInArray() {
    getArgs "_value &@_values" "${@}"
    local _val
    local _pos=0
    for _val in "${_values[@]}"; do
        if [[ "${_val}" == "${_value}" ]]; then 
            _return=${_pos}
            return 0;
        fi
        ((_pos+=1))
    done
    return -1
}

### Get a value from a config file
# usage: configInFile <file> <key>
function configInFile() {
    getArgs "_file _key" "${@}"
    _return=$(cat ${_file} | grep ${_key} | cut -d':' -f2-)
    return $?
}