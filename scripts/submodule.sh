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
        # 匹配 [submodule "name"] 行
        /^\[submodule/ {
            # 提取 submodule 名称
            match($0, /\[submodule "([^"]+)"\]/, arr);
            submodule_name = arr[1];
            path = "";
            url = "";
        }
        # 匹配 path 行，处理开头的空格
        /path/ {
            # 去掉开头的空格
            gsub(/^[ \t]+/, "", $2);
            path = $2;
        }
        # 匹配 url 行，处理开头的空格
        /url/ {
            # 去掉开头的空格
            gsub(/^[ \t]+/, "", $2);
            url = $2;
            # 提取 path 并把数据变成一行以供排序
            print path "\t" "[submodule \"" submodule_name "\"]" "\tpath = " path "\turl = " url;
        } 
        ' .gitmodules | sort -k1 | awk -F'\t' '
        {
            # 拆分 submodule 条目为多行
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
