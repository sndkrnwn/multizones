#!/bin/bash
# Sync github branch to feature branch script
# Created by pengjianqing@gmail.com, 09/19/2019
# e.g develop>pjq/develop_feature

CONFIG=config.txt.example

# get the config file
if [ $# = 2 ]; then
    if [ $1 = "-f" ]; then
        CONFIG=$2
        echo "Config file:$CONFIG"
    else
        echo "Usage: $0 -f config.txt"
        exit -1
    fi
else
    echo "Usage: $0 -f config.txt"
    exit -1
fi

# check the config is existing
if [ ! -f "$CONFIG" ]; then
    echo "${CONFIG} doesn't exist."
    exit -1
fi

# check the last command result, if failed, just exit -1
function check_result {
    RESULT=$1
    MSG="$2"
    if [ ${RESULT} -eq 0 ]; then
        echo "${MSG} success!"
    else
        echo "${MSG} failed!"
        exit -1
    fi
}

# sync branch
function git_branch_sync {
    FROM=$1
    TO=$2
    echo "Start Sync code from ${FROM} to ${TO}"
    git fetch origin ${FROM}
    git fetch origin ${TO}
    git checkout ${TO}
    check_result $? "git checkout ${TO}"
    git merge  --no-edit origin/${FROM}
    check_result $? "Merge ${FROM} > ${TO}"
    git push origin ${TO}
    check_result $? "Push to remote"
}

# parse one rule and start the sync task
function sync_one_rule {
    SYNC_RULE=$1
    echo "Sync rule ${SYNC_RULE}"
    FROM=`echo ${SYNC_RULE}|cut -d ">" -f1`
    TO=`echo ${SYNC_RULE}|cut -d ">" -f2`
    git_branch_sync ${FROM} ${TO}
}

# prepare the `clean` workspace and clone the repo
# function prepare_workspace {
#     echo "Prepare the workspace..."
#     [ -d ${WORKSPACE} ] || mkdir -p ${WORKSPACE}
#     cd ${WORKSPACE}
#     [ ! -z ${WORKSPACE} ] && [ ! -z "${LOCAL_REPO}" ] && [ -d ${LOCAL_REPO} ] &&  rm -rf ${LOCAL_REPO} 
#     git clone -b ${DEVELOP_BRANCH} ${REMOTE_REPO} ${LOCAL_REPO}
#     cd ${LOCAL_REPO}
# }

function read_config {
    echo "read config..."
    RULE=`cat ${CONFIG}|grep RULE|sed "s/ //g"|cut -d "=" -f2|sed "s/\"//g"|sed "s/|/ /g"`
    DEVELOP_BRANCH=`cat ${CONFIG}|sed "s/ //g"|grep DEVELOP_BRANCH|cut -d "=" -f2|sed "s/\"//g"`
    REMOTE_REPO=`cat ${CONFIG}|sed "s/ //g"|grep REMOTE_REPO|cut -d "=" -f2|sed "s/\"//g"`
    # LOCAL_REPO=`cat ${CONFIG}|sed "s/ //g"|grep LOCAL_REPO|cut -d "=" -f2|sed "s/\"//g"`
    # WORKSPACE=`cat ${CONFIG}|sed "s/ //g"|grep WORKSPACE|cut -d "=" -f2|sed "s/\"//g"`
}

function start_sync {
    echo "start sync..."
    for RULE_ONE in ${RULE}
    do
        sync_one_rule ${RULE_ONE}
        check_result $? "Sync ${RULE_ONE}"
    done
}

read_config
# prepare_workspace
start_sync