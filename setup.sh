#!/bin/bash

source_dir=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

export is_linux="$(uname -s | grep Linux)"
export is_macos="$(uname -s | grep Darwin)"

if [ $is_linux ]; then
    export is_in_docker=$(test -e /.dockerenv && echo yes)
fi

if [ $is_linux ]; then
    $source_dir/distros/manjaro/setup.sh
    $source_dir/distros/ubuntu/setup.sh
fi

if [ $is_macos ]; then
    $source_dir/distros/macos/setup.sh
fi

$source_dir/global/setup.sh
