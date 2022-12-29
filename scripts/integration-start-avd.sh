#!/usr/bin/env bash
chmod 777 -R /dev/kvm
adb start-server
emulator -avd test -wipe-data  -no-audio -no-boot-anim -no-window -accel on -gpu swiftshader_indirect
