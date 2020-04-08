#!/usr/bin/env bash

echo "$(date -Iminutes) Injecting Env Variables."
/inject-env-vars.sh $ACCESS_KEY $SECRET_KEY $BUCKET_NAME $PROXY_PASS_HOST $PROXY_HEADER_HOST

if [ $BASIC_AUTH == "yes" ]
then
  echo "Turning on basic auth. You need to mount the auth file at /.htpasswd..."
  sed -i '/^.*location/a \           \ auth_basic "Authentication Required";' /nginx.conf
  sed -i '/^.*auth_basic/a \           \ auth_basic_user_file /.htpasswd;' /nginx.conf
fi

echo "$(date -Iminutes) Starting Nginx Proxy."
/usr/local/nginx/sbin/nginx -c /nginx.conf
