#!/bin/sh
envsubst < /usr/share/nginx/html/config.template.js > /usr/share/nginx/html/config.js && nginx -g 'daemon off;' || cat /usr/share/nginx/html/config.js