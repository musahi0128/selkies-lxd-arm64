# selkies-lxd-arm64

Selkies setup script for Ubuntu Noble arm64 running inside LXD container.

Based on [Selkies Base Images from LinuxServer](https://github.com/linuxserver/docker-baseimage-selkies/tree/ubuntunoble).

## Setting up
```
git clone https://github.com/musahi0128/selkies-lxd-arm64.git
cd selkies-lxd-arm64
bash setup.i3.sh
# or
# bash setup.xfce4.sh
```

## Access
```
http://localhost:3000
https://localhost:3001
```

## Why

I was trying to install Selkies by following the [Selkies Getting Started](https://selkies-project.github.io/selkies/start/#getting-started) guide.

Unfortunately, they didn’t provide a portable Selkies-GStreamer build for ARM64. After successfully building it from source and gaining access to my VM, I found that performance was very poor.

After several failed attempts to find an alternative, I stumbled upon [Chromium - LinuxServer.io](https://docs.linuxserver.io/images/docker-chromium/), which worked flawlessly for my use case.

Curious about how the image was built and how it functioned, I decided to dig deeper and eventually adapted it to run inside an LXD container.
