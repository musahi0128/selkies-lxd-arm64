#!/bin/bash

# JS folder setup -- partially moved from 02-init-selkies-config.sh as it need to be setup on the lxd host
mkdir -pm1777 /dev/input
for i in $(seq 0 3); do
    mknod /dev/input/js$i c 13 $i
    chmod 777 /dev/input/js$i
    lxc config device add xubuntu js$i unix-char path=/dev/input/js$i
done
for i in $(seq 0 3); do
    mknod /dev/input/event$((1000+i)) c 13 $((1064+i))
    chmod 777 /dev/input/event$((1000+i))
    lxc config device add xubuntu event$((1000+i)) unix-char path=/dev/input/event$((1000+i))
done