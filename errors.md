```
server {
  listen 443 ssl http2;
  listen 443 quic;
  server_name domain.com;

  include /usr/local/nginx/conf/ssl/domain.com/domain.com.crt.key.conf;
...

  location / {
    add_header Alt-Svc 'h3=":443"; ma=86400';
...
}
```

with dual RSA + ECDSA SSL certs

```
/usr/local/nginx/conf/ssl/domain.com/domain.com.crt.key.conf
  ssl_dhparam /usr/local/nginx/conf/ssl/domain.com/dhparam.pem;
  ssl_certificate      /usr/local/nginx/conf/ssl/domain.com/domain.com-acme.cer;
  ssl_certificate_key  /usr/local/nginx/conf/ssl/domain.com/domain.com-acme.key;

  ssl_certificate      /usr/local/nginx/conf/ssl/domain.com/domain.com-acme-ecc.cer;
  ssl_certificate_key  /usr/local/nginx/conf/ssl/domain.com/domain.com-acme-ecc.key;
  
  #ssl_trusted_certificate /usr/local/nginx/conf/ssl/domain.com/domain.com-acme.cer;
  #ssl_trusted_certificate /usr/local/nginx/conf/ssl/domain.com/domain.com-acme-ecc.cer;
  ssl_trusted_certificate /usr/local/nginx/conf/ssl/domain.com/domain.com-dualcert-rsa-ecc.cer;
```

```
nginx -V
nginx version: nginx/1.23.4 (190523-215109-almalinux8-a08d9ff)
built by gcc 12.1.1 20220628 (Red Hat 12.1.1-3) (GCC) 
built with OpenSSL 1.1.1t+quic  7 Feb 2023
TLS SNI support enabled
```
> configure arguments: --with-ld-opt='-Wl,-E -L/opt/openssl-quic/lib -lssl -lcrypto -L/usr/local/zlib-cf/lib -L/usr/local/nginx-dep/lib -ljemalloc -Wl,-z,relro -Wl,-rpath,/opt/openssl-quic/lib:/usr/local/zlib-cf/lib:/usr/local/nginx-dep/lib -flto=12 -fuse-ld=gold' --with-cc-opt='-I/opt/openssl-quic/include -I/usr/local/zlib-cf/include -I/usr/local/nginx-dep/include -m64 -march=native -g -O3 -fstack-protector-strong -flto=12 -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wno-pointer-sign -fcode-hoisting -Wno-cast-function-type -Wno-format-extra-args -Wimplicit-fallthrough=0 -Wno-implicit-function-declaration -Wno-int-conversion -Wno-error=unused-result -Wno-unused-result -Wno-error=vla-parameter -Wp,-D_FORTIFY_SOURCE=2' --sbin-path=/usr/local/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --build=190523-215109-almalinux8-a08d9ff --with-compat --without-pcre2 --with-http_stub_status_module --with-http_secure_link_module --with-libatomic --with-http_gzip_static_module --with-http_sub_module --with-http_addition_module --with-http_image_filter_module=dynamic --with-http_geoip_module --with-stream_geoip_module --with-stream_realip_module --with-stream_ssl_preread_module --with-threads --with-stream --with-stream_ssl_module --with-http_realip_module --add-dynamic-module=../ngx-fancyindex-0.4.2 --add-module=../ngx_cache_purge-2.5.1 --add-dynamic-module=../ngx_devel_kit-0.3.0 --add-dynamic-module=../set-misc-nginx-module-0.32 --add-dynamic-module=../echo-nginx-module-0.62 --add-module=../redis2-nginx-module-0.15 --add-module=../ngx_http_redis-0.4.0-cmm --add-module=../memc-nginx-module-0.19 --add-module=../srcache-nginx-module-0.32 --add-dynamic-module=../headers-more-nginx-module-0.34 --with-pcre-jit --with-zlib=../zlib-cloudflare-1.3.0 --with-http_ssl_module --with-http_v2_module --with-http_v3_module

```
docker run --rm -it nghttp3 h2load --npn-list h3 -t1 -c10 -n100 -m32 https://domain.com/
starting benchmark...
spawning thread #0: 10 total client(s). 100 total requests
TLS Protocol: TLSv1.3
Cipher: TLS_AES_256_GCM_SHA384
Server Temp Key: X25519 253 bits
Application protocol: h3
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING


finished in 30.01s, 0.00 req/s, 547B/s
requests: 100 total, 60 started, 0 done, 0 succeeded, 100 failed, 100 errored, 0 timeout
status codes: 3 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 16.03KB (16415) total, 519B (519) headers (space savings 34.72%), 15.50KB (15869) data
UDP datagram: 89 sent, 56 received
                     min         max         mean         sd        +/- sd
time for request:        0us         0us         0us         0us     0.00%
time for connect:     2.68ms      6.31ms      4.62ms      1.66ms    66.67%
time to 1st byte:     4.36ms      4.36ms      4.36ms         0us   100.00%
req/s           :       0.00        0.00        0.00        0.00   100.00%
```

```
docker run --rm -it nghttp3 h2load --npn-list h2 -t1 -c10 -n100 -m32 https://domain.com/
starting benchmark...
spawning thread #0: 10 total client(s). 100 total requests
TLS Protocol: TLSv1.3
Cipher: TLS_AES_256_GCM_SHA384
Server Temp Key: X25519 253 bits
Application protocol: h2
progress: 10% done
progress: 20% done
progress: 30% done
progress: 40% done
progress: 50% done
progress: 60% done
progress: 70% done
progress: 80% done
progress: 90% done
progress: 100% done

finished in 15.83ms, 6318.72 req/s, 39.67MB/s
requests: 100 total, 100 started, 100 done, 100 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 100 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 642.96KB (658390) total, 18.07KB (18500) headers (space savings 30.19%), 622.66KB (637600) data
                     min         max         mean         sd        +/- sd
time for request:      699us      8.89ms      3.73ms      2.55ms    63.00%
time for connect:     1.85ms      5.52ms      3.89ms      1.27ms    60.00%
time to 1st byte:     6.07ms     14.02ms      9.15ms      2.82ms    70.00%
req/s           :     657.92     1505.55     1061.14      302.46    60.00%
```

Even running directly within container produces errors

```
docker run -it --name my-nghttp2 nghttp3 bash
```
```
h2load --npn-list h3 -t1 -c10 -n100 -m32 https://domain.com/
starting benchmark...
spawning thread #0: 10 total client(s). 100 total requests
TLS Protocol: TLSv1.3
Cipher: TLS_AES_256_GCM_SHA384
Server Temp Key: X25519 253 bits
Application protocol: h3
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
ngtcp2_conn_read_pkt: ERR_DRAINING
```

```
curl --http3 -Iv https://domain.com/
*   Trying 1.2.3.4:443...
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: none
*  subjectAltName: host "domain.com" matched cert's "domain.com"
* Verified certificate just fine
* Connected to domain.com (1.2.3.4) port 443 (#0)
* using HTTP/3
* Using HTTP/3 Stream ID: 0 (easy handle 0x559094f83a20)
> HEAD / HTTP/3
> Host: domain.com
> User-Agent: curl/8.1.1-DEV
> Accept: */*
> 
* ngtcp2_conn_writev_stream returned error: ERR_DRAINING
* ngtcp2_conn_writev_stream returned error: ERR_DRAINING
* ngtcp2_conn_writev_stream returned error: ERR_DRAINING
```

# Cloudflare HTTP/3

Cloudflare proxied HTTP/3 works though

```
h2load --npn-list h3 -t1 -c10 -n100 -m32 https://domain.com/
starting benchmark...
spawning thread #0: 10 total client(s). 100 total requests
TLS Protocol: TLSv1.3
Cipher: TLS_AES_128_GCM_SHA256
Server Temp Key: X25519 253 bits
Application protocol: h3
progress: 10% done
progress: 20% done
progress: 30% done
progress: 40% done
progress: 50% done
progress: 60% done
progress: 70% done
progress: 80% done
progress: 90% done
progress: 100% done

finished in 78.56ms, 1272.93 req/s, 8.31MB/s
requests: 100 total, 100 started, 100 done, 100 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 100 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 668.23KB (684264) total, 43.87KB (44927) headers (space savings 24.69%), 622.66KB (637600) data
UDP datagram: 184 sent, 779 received
                     min         max         mean         sd        +/- sd
time for request:    24.57ms     69.01ms     45.87ms     12.47ms    57.00%
time for connect:     5.80ms     10.57ms      8.06ms      1.54ms    60.00%
time to 1st byte:    30.37ms     51.93ms     40.75ms      6.46ms    70.00%
req/s           :     128.77      217.41      143.65       26.25    90.00%
```

```
curl --http3 -I https://domain.com/
HTTP/3 200 
date: Sat, 20 May 2023 07:34:37 GMT
content-type: text/html; charset=utf-8
last-modified: Sat, 20 May 2023 03:19:22 GMT
vary: Accept-Encoding
x-powered-by: centminmod
alt-svc: h3=":443"; ma=86400, h3-29=":443"; ma=86400
cf-cache-status: DYNAMIC
report-to: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report\/v3?s=p6BPUNU2mZDRoE69HEoyFNz%2BaUthDfYPckrVP1E76Wl7nr4O%2BLOjFvGV3E90jhcLe1%2BVcQXzfi516%2Fkn4Wo2qDHpvU0HH4b9JrqdVdDvJHnoTfizAJuu5ASuEbrbVvDsUw%3D%3D"}],"group":"cf-nel","max_age":604800}
nel: {"success_fraction":0,"report_to":"cf-nel","max_age":604800}
server: cloudflare
cf-ray: 7ca2e5f1783603d9-DFW
```