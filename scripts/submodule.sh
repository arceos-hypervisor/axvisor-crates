#!/bin/bash

cmd=$1

if [ -z $cmd ]; then
    echo "Usage: $0 <init|update|sync>"
    exit 1
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")
# Import $ROOT and $CRATES.
source "$SCRIPT_DIR/crate_list.sh"

mkdir -p crates

for repo in ${CRATES[@]};
do
    if [ "$cmd" == "init" ]; then
        git submodule add $ROOT/$repo.git crates/$repo
    elif [ "$cmd" == "update" ]; then
        git submodule update --init --remote crates/$repo
        # git add crates/$repo
        # git commit -m "update submodule $repo to latest"
    elif [ "$cmd" == "sync" ]; then
        git submodule update --init crates/$repo
    else
        echo "Invalid command: $cmd"
        echo "Valid commands: init, update, sync"
        exit 1
    fi
done
