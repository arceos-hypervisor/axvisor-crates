#!/bin/bash

cmd=$1

if [ -z $cmd ]; then
    echo "Usage: $0 <init|update|sync>"
    exit 1
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")
# Import $ROOT and $CRATES.
crate_list=$SCRIPT_DIR/crate_list.sh
source $crate_list

mkdir -p crates

for repo in "${REPOS[@]}";
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
            repo = "";
            url = "";
        }
        # Extract path.
        /path/ {
            # Strip whitespaces.
            gsub(/^[ \t]+/, "", $2);
            path = $2;
            match(path, /crates\/(\S+)/, arr);
            repo = arr[1];
        }
        # Extract url.
        /url/ {
            # Strip whitespaces.
            gsub(/^[ \t]+/, "", $2);
            url = $2;
            # Extract repo as the sorting key, and condense the item into single line.
            print repo "\t" "[submodule \"" submodule_name "\"]" "\tpath = " path "\turl = " url;
        } 
        ' .gitmodules | sort -k1 | awk -v crate_list="$crate_list" -F'\t' '
        {
            cmd = crate_list " is_repo " $1
            if (system(cmd) != 0) {
                printf "\033[31m\033[1m%s is not in the REPOS list!\033[0m", $1 > "/dev/stderr"
                exit 1
            }
            # Split submodule item into lines.
            print $2;
            print "  " $3;
            print "  " $4;
        }
        ' > .gitmodules.sorted || exit 1
    mv .gitmodules.sorted .gitmodules
}

if [ "$cmd" == "init" ]; then
    sort_submodule
fi
