
## Motivation

This image was ~~created~~ modified for use with shinyproxy. This was for use as part of an auth solution for content 
hosted in (http://minio.io/)[Minio], which implements the AWS S3 API. 

## Use
### Setting up Minio Creds
These steps setup a Minio user to be used by the auth proxy below, 

**NB** User scoped creds are a relatively new feature in Minio, so emptor cave.

1. Adding user with read only privileges: `mc admin user add <Minio config name, e.g. edge> 
<Minio Access Key> <Minio Secret Key>`
2. Adding policy for the relevant bucket (see (this config for an example)[./config/get-covid-only.json]): `mc admin 
policy add <Minio config name> <policy name, e.g. get-covid-only> <path to policy file, e.g. 
config/get-covid-only.json>`
3. Bind policy to user: `mc admin policy set edge <Policy name> user=<Minio Access Key>`

That's it - use the `ACCESS KEY` and `SECRET KEY` from step up in your nginx config.

### Proxy Use

#### Running
To start the container in interactive mode, on port `8000`:
```
docker run -it --rm \
           -p 8000:8000 \
           --name minio-proxy-test \
           --env ACCESS_KEY="<ACCESS NAME goes here>" \
           --env SECRET_KEY="<SECRET NAME goes here>" \
           --env BUCKET_NAME="<BUCKET NAME goes here>" \
           cityofcapetown/nginx-s3-proxy
```

Additionally, the following env variables can be overwritten:
* `PROXY_PASS_HOST` - the host (including protocol) to pass the request to
* `PROXY_HEADER_HOST` - the hostname (*NB* not including protocol) to pass in the S3 request

#### Customisation
The image uses [this config file](./config/nginx.conf) in the container at: `/nginx.conf`, however this can be 
overwridden `-v` option to mount one from your host.

```
docker run -p 8000:8000 -v /path/to/nginx.conf:/nginx.conf cityofcapetown/nginx-s3-proxy 
```

If you want to store the cache on the host, bind a path to `/data/cache`:

```
docker run -p 8000:8000 -v /path/to/nginx.conf:/nginx.conf -v /my/path:/data/cache cityofcapetown/nginx-s3-proxy 
```

Feel free to alter the `-p` param if you wish to bind the port differently onto the host.

Example nginx.conf file:

```
worker_processes 2;
pid /run/nginx.pid;
daemon off;

events {
	worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_names_hash_bucket_size 64;
    
    include /usr/local/nginx/conf/mime.types;
    default_type application/octet-stream;
    
    access_log /usr/local/nginx/logs/access.log;
    error_log  /usr/local/nginx/logs/error.log;
    
    gzip on;
    gzip_disable "msie6";
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    proxy_cache_lock on;
    proxy_cache_lock_timeout 60s;
    proxy_cache_path /data/cache levels=1:2 keys_zone=s3cache:10m max_size=30g;

    server {
        listen     8000;

        location / {
            proxy_pass https://your-bucket.s3.amazonaws.com;

            aws_access_key your-access-key;
            aws_secret_key your-secret-key;
            s3_bucket your-bucket;

            proxy_set_header Authorization $s3_auth_token;
            proxy_set_header x-amz-date $aws_date;

            proxy_cache        s3cache;
            proxy_cache_valid  200 302  24h;
        }
    }
}
```

Things you want to tweak include:

* proxy_pass
* aws_access_key
* aws_secret_key
* s3_bucket


