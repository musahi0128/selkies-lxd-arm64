#!/bin/bash

# default file copies first run -- skipped, not using openbox

# XDG Home -- skipped, revisit if something's wrong

# Locale Support -- skipped, revisit if something's wrong

# Remove window borders -- skipped, not using openbox

# Fullscreen everything in openbox unless the user explicitly disables it -- skipped, not using openbox

# Add proot-apps -- skipped, not using proot-apps

# set env based on vars --skipped, defined in selkies.service directly

# JS folder setup -- partially moved to 00-lxd-host-joystick.sh as it need to be setup on the lxd host
touch /tmp/selkies_js.log
chmod 777 /tmp/selkies_js.log
for i in $(seq 0 3); do
  chmod 777 /dev/input/js$i
  chmod 777 /dev/input/event$((1000+i))
done

# Manifest creation
cat > /usr/share/selkies/www/manifest.json <<EOF
{
  "name": "Selkies",
  "short_name": "Selkies",
  "manifest_version": 2,
  "version": "1.0.0",
  "display": "fullscreen",
  "background_color": "#000000",
  "theme_color": "#000000",
  "icons": [
    {
      "src": "icon.png",
      "type": "image/png",
      "sizes": "180x180"
    }
  ],
  "start_url": "/"
}
EOF