#!/bin/bash

source_dir=$(pushd "$(dirname "$0")" >/dev/null && pwd && popd >/dev/null || exit)

for setup in "$source_dir"/distros/*/setup.sh; do
  "$setup"
done

"$source_dir"/global/setup.sh
