#!/bin/bash

source_dir=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

$source_dir/distros/arch/setup.sh
$source_dir/distros/ubuntu/setup.sh

$source_dir/distros/macos/setup.sh

$source_dir/global/setup.sh
