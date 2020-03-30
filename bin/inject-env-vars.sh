#!/usr/bin/env bash

ACCESS_KEY="$1"
SECRET_KEY="$2"
BUCKET_NAME="$3"

ROOT_HTML_PATH=${4:-index.html}
PROXY_PASS_HOST=${5:-https://172.29.100.54}
PROXY_HEADER_HOST=${6:-ds2.capetown.gov.za}

echo "Replac[ing] template variables..."

cp /nginx.conf /tmp/nginx.conf.template
sed -i "s/<ACCESS_KEY GOES HERE>/"$ACCESS_KEY"/" /tmp/nginx.conf.template
sed -i "s/<SECRET_KEY GOES HERE>/"$SECRET_KEY"/" /tmp/nginx.conf.template
sed -i "s/<BUCKET_NAME GOES HERE>/"$BUCKET_NAME"/" /tmp/nginx.conf.template
sed -i "s/<ROOT_HTML_PATH GOES HERE>/"$ROOT_HTML_PATH"/" /tmp/nginx.conf.template
sed -i "s#<PROXY_PASS_HOST GOES HERE>#"$PROXY_PASS_HOST"#" /tmp/nginx.conf.template
sed -i "s/<PROXY_HEADER_HOST GOES HERE>/"$PROXY_HEADER_HOST"/" /tmp/nginx.conf.template
cp /tmp/nginx.conf.template /nginx.conf

echo "... Replac[ed] template variables."
