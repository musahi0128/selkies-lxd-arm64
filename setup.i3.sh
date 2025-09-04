#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
sudo mkdir -p /root/.config/rclone
mkdir -p ~/.config/rclone
sudo touch /root/.config/rclone/rclone.conf
touch ~/.config/rclone/rclone.conf
mkdir -p $HOME/Desktop
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -yq acl dbus-x11 libepoxy0 libnginx-mod-http-fancyindex locales-all nginx pipx pulseaudio ssl-cert unzip x11-xkb-utils xcvt xdotool xsel xvfb \
    i3 dmenu 
sudo apt clean
curl https://rclone.org/install.sh | sudo bash
sudo usermod -aG audio,video $USER
pipx install udocker
udocker pull ghcr.io/linuxserver/baseimage-selkies:ubuntunoble
udocker create --name=selkies_tmp ghcr.io/linuxserver/baseimage-selkies:ubuntunoble
export SELKIES_ROOTFS="$(find ~/.udocker -name selkies_joystick_interposer.so | sed 's|/usr/lib/selkies_joystick_interposer.so||')"
sudo rclone copy -L $SELKIES_ROOTFS/usr/lib/selkies_joystick_interposer.so /usr/lib/
sudo rclone copy -L $SELKIES_ROOTFS/opt/lib/libudev.so.1.0.0-fake /opt/lib/
sudo rclone copy -L $SELKIES_ROOTFS/usr/bin/Xvfb /usr/bin/
sudo rclone copy -L $SELKIES_ROOTFS/lsiopy /lsiopy
sudo rclone copy -L $SELKIES_ROOTFS/usr/share/selkies/www /usr/share/selkies/www
sudo chmod a+x /lsiopy/bin/*
sudo chmod a+x /usr/bin/Xvfb
sudo bash 01-init-nginx.sh
sudo bash 02-init-selkies-config.sh
udocker rm selkies_tmp
udocker rmi ghcr.io/linuxserver/baseimage-selkies:ubuntunoble
sudo tee /etc/pulse/default.pa.d/selkies.pa > /dev/null <<EOF
load-module module-null-sink sink_name="output" sink_properties=device.description="output"
load-module module-null-sink sink_name="input" sink_properties=device.description="input"
EOF
sed -i 's/REPLACE_TITLE/i3/g' selkies.service
sed -i 's|/usr/bin/REPLACE_DESKTOP|/usr/bin/i3|g' desktop.service
rclone copy . ~/.config/systemd/user/ --include="*.service"
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user disable pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket > /dev/null
systemctl --user mask pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket > /dev/null
systemctl --user enable --now xvfb desktop pulseaudio selkies
# sudo reboot