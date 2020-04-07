FROM debian:jessie

WORKDIR /tmp

RUN apt-get -y update
RUN apt-get -y install \
               curl \
               build-essential \
               libpcre3 \
               libpcre3-dev \
               zlib1g-dev \
               libssl-dev \
               git \
               wget \
               moreutils && \
    curl -LO http://nginx.org/download/nginx-1.9.3.tar.gz && \
    tar zxf nginx-1.9.3.tar.gz && \
    cd nginx-1.9.3 && \
    git clone -b AuthV2 https://github.com/anomalizer/ngx_aws_auth.git && \
    ./configure --with-http_ssl_module --add-module=ngx_aws_auth && \
    make install && \
    cd /tmp && \
    rm -f nginx-1.9.3.tar.gz && \
    rm -rf nginx-1.9.3 && \
    apt-get purge -y curl git && \
    apt-get autoremove -y

# Pull pusher_oauth
RUN wget -O pusher.tar.gz \
    https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v5.1.0/oauth2_proxy-v5.1.0.linux-amd64.go1.14.tar.gz \
 && tar xvzf pusher.tar.gz \
 && mv oauth* pusher \
 &&  mv pusher/oauth2_proxy /usr/local/bin/oauth2_proxy \
 && rm -rf /tmp/*

RUN mkdir -p /data/cache

COPY bin/inject-env-vars.sh /
COPY bin/run.sh /
COPY config/nginx.conf /

RUN chmod +x /inject-env-vars.sh
RUN chmod +x /run.sh

ENV ROOT_HTML_PATH index.html
ENV PROXY_PASS_HOST https://172.29.100.54
ENV PROXY_HEADER_HOST ds2.capetown.gov.za

EXPOSE 8000

CMD ["/bin/bash", "/run.sh"]
