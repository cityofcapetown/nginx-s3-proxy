#!/usr/bin/env bash

echo "$(date -Iminutes) Injecting Env Variables."
/inject-env-vars.sh $ACCESS_KEY $SECRET_KEY $BUCKET_NAME $ROOT_HTML_PATH $PROXY_PASS_HOST $PROXY_HEADER_HOST

echo "$(date -Iminutes) Starting Nginx and OAuth2 proxy."
parallel -j 2 -- '/usr/local/bin/oauth2_proxy' '/usr/local/nginx/sbin/nginx -c /nginx.conf'