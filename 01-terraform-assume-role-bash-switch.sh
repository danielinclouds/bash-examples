#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# ---------------------------------------------
# Switch
# ---------------------------------------------
function usage() {
    echo "Usage --apply or --destroy"
}

case $1 in
    -f | --apply )          subcommand="apply"
                            ;;
    -i | --destroy )        subcommand="destroy"
                            ;;
    -h | --help )           usage
                            exit
                            ;;
    * )                     usage
                            exit 1
esac


# ---------------------------------------------
# Helper functions
# ---------------------------------------------
function assume_aws_role() {
    
    if [[ $# -ne 1 ]]; then
        echo "Error: Provide environment name"
        exit 1
    fi

    unset AWSUME
    local AWSUME=$(awsume -s "$1")
    AWS_ACCESS_KEY_ID=$(echo "$AWSUME"     | grep AWS_ACCESS_KEY_ID     | cut -d'=' -f2)
    AWS_SECRET_ACCESS_KEY=$(echo "$AWSUME" | grep AWS_SECRET_ACCESS_KEY | cut -d'=' -f2)
    AWS_SESSION_TOKEN=$(echo "$AWSUME"     | grep AWS_SESSION_TOKEN     | cut -d'=' -f2)
    AWS_SECURITY_TOKEN=$(echo "$AWSUME"    | grep AWS_SECURITY_TOKEN    | cut -d'=' -f2)
    AWSUME_PROFILE=$(echo "$AWSUME"        | grep AWSUME_PROFILE        | cut -d'=' -f2)
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN
    export AWS_SECURITY_TOKEN
    export AWSUME_PROFILE
}

# ---------------------------------------------
# DEV
# ---------------------------------------------
assume_aws_role dev

pushd "${DIR}/development"

    terraform init
    terraform "$subcommand" -auto-approve

popd

