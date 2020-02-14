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

# Function to clone the lib
function devOpsLibsClone() {

    GIT_REPO=${1}
    GIT_BRANCH=${2}
    GIT_DIR=${3}
    GIT_STATUS=${4}

    # Check and enable set e
    set_e_enabled=${-//[^e]/}
    [ ${set_e_enabled} ] || set -e

    # If clone is not local
    if [ ! "${DOLIBS_LOCAL_MODE_DIR}" ]; then
        # Check if git is present
        if [ $(which git &> /dev/null || echo $?) ]; then echo 'Git command not found'; fi

        ### Clone / update the libraries ###
        echo "Retrieving DevOps Libs code from '${GIT_REPO}'..."

        # Get the code        
        if [ ! -d ${GIT_DIR} ]; then            
            git clone -b ${GIT_BRANCH} --single-branch https://git@github.com/${GIT_REPO}.git ${GIT_DIR}            
        else
            git -C ${GIT_DIR} pull
        fi

        # Update retrieved lib status
        #mkdir -p $(dirname ${GIT_STATUS})
        cat << EOF > ${GIT_STATUS}
branch:${GIT_BRANCH}
hash:$(cd ${GIT_DIR}; git rev-parse HEAD)
updated:$(date)
user:$(git config user.name)
email:$(git config user.email)
hostname:$(hostname)
EOF
    fi

    [ ${set_e_enabled} ] || set +e # Disable set e
}

# If Core library was not yet loaded
if [ ! "${DOLIBS_CORE_FUNCT}" ]; then

    ###############################
    export DOLIBS_TMP_DIR="${DOLIBS_DIR}/.libtmp/${DOLIBS_BRANCH}"
    export DOLIBS_STATUS="${DOLIBS_DIR}/dolibs.status"
    ###############################

    # If it was set to use local tmp folder
    if [ "${DOLIBS_LOCAL_MODE_DIR}" ]; then
        if [ ! -d ${DOLIBS_LOCAL_MODE_DIR} ]; then echo 'ERROR: invalid local path to clone!' >&2; exit -1; fi
        export DOLIBS_TMP_DIR=${DOLIBS_LOCAL_MODE_DIR}
        export DOLIBS_MODE='local'
        # echo "Using Local mode from '${DOLIBS_LOCAL_MODE_DIR}'"        
    # Check if operation mode was specified
    elif [ ! ${DOLIBS_MODE} ]; then # Set default mode case not provided
        if [ "${CI}" ]; then
            echo "DevOps Libs running in GitLab! setting to online mode..."
            export DOLIBS_MODE='online'
        else
            export DOLIBS_MODE=${DOLIBS_DEFAULT_MODE}
        fi
    fi

    ############## VALIDATE AUTO OPERATION MODE #################
    if [[ ${DOLIBS_MODE} == 'auto' ]]; then    
        if [[ ${DOLIBS_MODE} == 'auto' && ! -f ${DOLIBS_DIR}/core.sh ]]; then 
            echo "DevOps Libs not found! forcing online mode..."
            export DOLIBS_MODE='online'; 
        elif [[ $(cat ${DOLIBS_STATUS} | grep branch | awk -F : '{print $NF}') != ${DOLIBS_BRANCH} ]]; then
            echo "DevOps Lib Branch has changed! forcing online mode..."
            export DOLIBS_MODE='online'
        fi
    fi
    #########################################################

    # Show using branch
    if [[ ${DOLIBS_MODE} == 'offline' ]]; then 
        echo "---> DevOps Libs (${DOLIBS_MODE}) <---"
    elif [[ ${DOLIBS_MODE} == 'local' ]]; then 
        echo "---> DevOps Libs Local Source: '${DOLIBS_LOCAL_MODE_DIR}' (${DOLIBS_MODE}) <---"        
    else
        echo "---> DevOps Libs branch: '${DOLIBS_BRANCH}' (${DOLIBS_MODE}) <---"        
    fi

    # Check if in on line mode
    if [[ ${DOLIBS_MODE} == 'online' || ${DOLIBS_MODE} == 'local' ]]; then
        devOpsLibsClone ${DOLIBS_REPO} ${DOLIBS_BRANCH} ${DOLIBS_TMP_DIR} ${DOLIBS_STATUS}

        # If it is the main lib
        #if [[ ${DOLIBS_REPO} == ${GIT_REPO} ]]; then    
        echo "Installing Core library code...."

        ### Create dir and copy the Core lib inside the project ###
        mkdir -p ${DOLIBS_DIR}
        cp ${DOLIBS_TMP_DIR}/libs/*.* ${DOLIBS_DIR}
        cp ${DOLIBS_TMP_DIR}/libs/.gitignore ${DOLIBS_DIR}

        # Copy license
        cp ${DOLIBS_TMP_DIR}/LICENSE ${DOLIBS_DIR}/LICENSE
        cp ${DOLIBS_TMP_DIR}/NOTICE ${DOLIBS_DIR}/NOTICE

        # Copy the DevOps Libs help
        cp ${DOLIBS_TMP_DIR}/README.md ${DOLIBS_DIR}/README.md
        cp ${DOLIBS_TMP_DIR}/libs/README.md ${DOLIBS_DIR}/DEVELOPMENT.md
        #fi        
    fi

    ### Include DevOps Libs ###
    if [ -f ${DOLIBS_DIR}/core.sh ]; then        
        source ${DOLIBS_DIR}/core.sh
        if [ $? -ne 0 ]; then echo "Could not import DevOps Libs"; exit 1; fi
    else
        echo "Could not find DevOps Libs (offline mode?)"
        exit 1
    fi
fi