#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
# Import $ROOT and $CRATES.
source "$SCRIPT_DIR/crate_list.sh"

echo '| Crate | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[crates.io](crates.io)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Documentation | Description |'
echo '|----|:--:|:--:|----|'

for c in ${CRATES[@]};
do
    subcrate=0
    platform_crate=0
    if [[ $c == axvirtio-* ]]; then
        repo="axvirtio"
        subcrate=1
    else
        repo="$c"
        subcrate=0
    fi

    if [[ $subcrate == 0 ]]; then
        url="$ROOT/$c"
        toml="crates/$repo/Cargo.toml"
    elif [[ $platform_crate == 1 ]]; then
        url="$ROOT/$repo/tree/main/platforms/$c"
        toml="crates/$repo/platforms/$c/Cargo.toml"
    else
        url="$ROOT/$repo/tree/main/$c"
        toml="crates/$repo/$c/Cargo.toml"
    fi

    description=`cat $toml | sed -n 's/^description = "\([^"]*\)"/\1/p'`
    if [[ $description != *. ]]; then
        description+="."
    fi

    if [[ `curl -s https://crates.io/api/v1/crates/$c | grep arceos-hypervisor` ]]
    then
        # In crates.io
        crates_io="[![Crates.io](https://img.shields.io/crates/v/$c)](https://crates.io/crates/$c)"
        doc="[![Docs.rs](https://docs.rs/$c/badge.svg)](https://docs.rs/$c)"
    else
        # Not in crates.io
        crates_io="N/A"
        if [[ $subcrate == 1 ]]; then
            doc_url="https://arceos-hypervisor.github.io/$repo/$c"
        else
            doc_url="https://arceos-hypervisor.github.io/$c"
        fi
        doc="[![Docs.rs](https://img.shields.io/badge/docs-pages-green)]($doc_url)"
    fi
    echo "| [$c]($url) | $crates_io | $doc | $description |"
done
