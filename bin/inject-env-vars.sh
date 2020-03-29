#!/usr/bin/env bash

ACCESS_KEY="$1"
SECRET_KEY="$2"
BUCKET_NAME=${3:-}

PROXY_PASS_HOST=${4:-https://172.29.100.54}
PROXY_HEADER_HOST=${5:-ds2.capetown.gov.za}

echo "Replac[ing] template variables..."

sed -i "s/<ACCESS_KEY GOES HERE>/"$ACCESS_KEY"/" /nginx.conf
sed -i "s/<SECRET_KEY GOES HERE>/"$SECRET_KEY"/" /nginx.conf
sed -i "s/<BUCKET_NAME GOES HERE>/"$BUCKET_NAME"/" /nginx.conf
sed -i "s#<PROXY_PASS_HOST GOES HERE>#"$PROXY_PASS_HOST"#" /nginx.conf
sed -i "s/<PROXY_HEADER_HOST GOES HERE>/"$PROXY_HEADER_HOST"/" /nginx.conf

echo "... Replac[ed] template variables."
