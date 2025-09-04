#!/bin/bash

if [ ! -f "./docker-baseimage-selkies/root/defaults/default.conf" ]; then
    git clone --single-branch --branch ubuntunoble https://github.com/linuxserver/docker-baseimage-selkies.git
fi

# nginx Path
NGINX_CONFIG=/etc/nginx/sites-available/default

# user passed env vars
CPORT="${CUSTOM_PORT:-3000}"
CHPORT="${CUSTOM_HTTPS_PORT:-3001}"
CWS="${CUSTOM_WS_PORT:-8082}"
#CUSER="${CUSTOM_USER:-abc}"
CUSER="ubuntu"
SFOLDER="${SUBFOLDER:-/}"
DISABLE_IPV6="true"

cp ./docker-baseimage-selkies/root/defaults/default.conf ${NGINX_CONFIG}

# create self signed cert -- uses snakeoil certificate instead
sed -i "s|/config/ssl/cert.pem|/etc/ssl/certs/ssl-cert-snakeoil.pem|g" ${NGINX_CONFIG}
sed -i "s|/config/ssl/cert.key|/etc/ssl/private/ssl-cert-snakeoil.key|g" ${NGINX_CONFIG}

# modify nginx config
sed -i "s/3000/$CPORT/g" ${NGINX_CONFIG}
sed -i "s/3001/$CHPORT/g" ${NGINX_CONFIG}
sed -i "s/CWS/$CWS/g" ${NGINX_CONFIG}
sed -i "s|SUBFOLDER|$SFOLDER|g" ${NGINX_CONFIG}
sed -i "s|REPLACE_HOME|/home/$CUSER|g" ${NGINX_CONFIG}
# s6-setuidgid abc mkdir -p $HOME/Desktop
if [ ! -z ${DISABLE_IPV6+x} ]; then
  sed -i '/listen \[::\]/d' ${NGINX_CONFIG}
fi
if [ ! -z ${PASSWORD+x} ]; then
  printf "${CUSER}:$(openssl passwd -apr1 ${PASSWORD})\n" > /etc/nginx/.htpasswd
  sed -i 's/#//g' ${NGINX_CONFIG}
fi
if [ ! -z ${DEV_MODE+x} ]; then
  sed -i \
    -e 's:location / {:location /null {:g' \
    -e 's:location /devmode:location /:g' \
    ${NGINX_CONFIG}
fi

# copy favicon -- skipped

# fix for Download Files button
setfacl -m u:www-data:--x /home/$CUSER
setfacl -m u:www-data:--x /home/$CUSER/Desktop
sed -i "s|const diskPathPrefix = '/config/Desktop/';|const diskPathPrefix = '/home/$CUSER/Desktop/';|" /usr/share/selkies/www/nginx/footer.html

systemctl reload nginx

rm -rf ./docker-baseimage-selkies