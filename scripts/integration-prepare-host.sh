#!/usr/bin/env bash
if ! command -v apk &>/dev/null; then
  apt update && apt install -y -qq docker.io ldnsutils grep scrcpy ffmpeg
else
  apk update && apk add docker drill grep scrcpy ffmpeg
fi
