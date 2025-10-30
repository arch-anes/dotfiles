#!/bin/sh
# Ref: https://github.com/aejsmith/vkdevicechooser
if [ "$(hostname)" = "h500i" ]; then
    export ENABLE_DEVICE_CHOOSER_LAYER=1
    export VULKAN_DEVICE_INDEX=1
fi
