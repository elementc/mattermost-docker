#!/bin/sh

# Define default value for app container hostname and port
APP_HOST=${APP_HOST:-app}
APP_PORT_NUMBER=${APP_PORT_NUMBER:-8000}

if [ -e /etc/nginx/conf.d/mattermost.conf ]; then
  echo "Found an existing config. Deleting..."
  rm /etc/nginx/conf.d/mattermost.conf
fi

# Check if SSL should be enabled (if certificates exists)
if [ -f "/cert/cert.pem" -a -f "/cert/key-no-password.pem" ]; then
  echo "Found certificate and key, linking ssl config."
  ssl="-ssl"
else
  echo "Linking plain config."
fi
# Linking Nginx configuration file
ln -s /etc/nginx/sites-available/mattermost$ssl /etc/nginx/conf.d/mattermost.conf

# Setup app host and port on configuration file
sed -i "s/{%APP_HOST%}/${APP_HOST}/g" /etc/nginx/conf.d/mattermost.conf
sed -i "s/{%APP_PORT%}/${APP_PORT_NUMBER}/g" /etc/nginx/conf.d/mattermost.conf

# Run Nginx
nginx -g 'daemon off;'