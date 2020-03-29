#!/usr/bin/env bash
set -e

echo "$(date -Iminutes) Injecting Env Variables."
/inject-env-vars.sh $ACCESS_KEY $SECRET_KEY $BUCKET_NAME $PROXY_PASS_HOST $PROXY_HEADER_HOST

echo "$(date -Iminutes) Starting Nginx Proxy."
nginx -g 'daemon off'