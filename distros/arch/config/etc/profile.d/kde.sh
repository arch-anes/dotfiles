#!/bin/sh
# Ref: https://www.reddit.com/r/linux_gaming/comments/1h56hei/counterstrike_2_mouse_not_captured_properly_under/
export SDL_VIDEO_DRIVER=x11
export SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL=1
