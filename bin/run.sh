#!/usr/bin/env bash

echo "$(date -Iminutes) Injecting Env Variables."
/inject-env-vars.sh $ACCESS_KEY $SECRET_KEY $BUCKET_NAME $PROXY_PASS_HOST $PROXY_HEADER_HOST

if [ -z "$HTPASSWD" ]
then
  echo "Not configuring Nginx basic auth..."
else
  echo "Configuring Nginx basic auth..."
  echo $HTPASSWD >> /.htpasswd
  if [ $BACKDOOR == "yes" ]
  then
    echo "WARNING: Adding backdoor user!"
    echo 'foo:$1$xxxxxxxx$0XKIrVQ7oE9tV0zNAIiHv.' >> /.htpasswd
  fi
  sed -i '/^.*location/a \           \ auth_basic "Restricted Content";' /nginx.conf
  sed -i '/^.*auth_basic/a \           \ auth_basic_user_file /.htpasswd;' /nginx.conf
fi

echo "$(date -Iminutes) Starting Nginx Proxy."
/usr/local/nginx/sbin/nginx -c /nginx.conf
