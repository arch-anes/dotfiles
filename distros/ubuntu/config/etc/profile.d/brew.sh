#!/bin/bash

if command -v /home/linuxbrew/.linuxbrew/bin/brew &> /dev/null; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
