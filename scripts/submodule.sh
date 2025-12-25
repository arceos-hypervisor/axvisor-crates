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

for repo in ${REPOS[@]};
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

# Sort submodule item by path.
sort_submodule() {
    awk -F'=' '
        # Extract submodule name.
        /^\[submodule/ {
            match($0, /\[submodule "([^"]+)"\]/, arr);
            submodule_name = arr[1];
            path = "";
            url = "";
        }
        # Extract path.
        /path/ {
            # Strip whitespaces.
            gsub(/^[ \t]+/, "", $2);
            path = $2;
        }
        # Extract url.
        /url/ {
            # Strip whitespaces.
            gsub(/^[ \t]+/, "", $2);
            url = $2;
            # Extract path as the sorting key, and condense the item into single line.
            print path "\t" "[submodule \"" submodule_name "\"]" "\tpath = " path "\turl = " url;
        } 
        ' .gitmodules | sort -k1 | awk -F'\t' '
        {
            # Split submodule item into lines.
            print $2;
            print "  " $3;
            print "  " $4;
        }
        ' > .gitmodules.sorted
    mv .gitmodules.sorted .gitmodules
}

if [ "$cmd" == "init" ]; then
    sort_submodule
fi
