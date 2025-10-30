#!/bin/bash

############
### Vars ###
############
is_macos="$(uname -s | grep Darwin)"
if [ ! "$is_macos" ]; then
    echo "Not MacOS. Skipping package installation."
    exit 0
fi

source_dir=$(pushd "$(dirname "$0")" >/dev/null && pwd && popd >/dev/null || exit)

################
### Packages ###
################
NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install "$(cat "$source_dir"/packages/*)"
