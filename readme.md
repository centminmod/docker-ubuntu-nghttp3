```
docker build -t nghttp3 .
```
```
docker run --rm -it nghttp3 h2load --version
h2load nghttp2/1.54.0-DEV

docker run --rm -it nghttp3 nghttp --version
nghttp nghttp2/1.54.0-DEV
```
```
docker run --rm -it nghttp3 h2load --help
Usage: h2load [OPTIONS]... [URI]...
benchmarking tool for HTTP/2 server

  <URI>       Specify URI to access.   Multiple URIs can be specified.
              URIs are used  in this order for each  client.  All URIs
              are used, then  first URI is used and then  2nd URI, and
              so  on.  The  scheme, host  and port  in the  subsequent
              URIs, if present,  are ignored.  Those in  the first URI
              are used solely.  Definition of a base URI overrides all
              scheme, host or port values.
Options:
  -n, --requests=<N>
              Number of  requests across all  clients.  If it  is used
              with --timing-script-file option,  this option specifies
              the number of requests  each client performs rather than
              the number of requests  across all clients.  This option
              is ignored if timing-based  benchmarking is enabled (see
              --duration option).
              Default: 1
  -c, --clients=<N>
              Number  of concurrent  clients.   With  -r option,  this
              specifies the maximum number of connections to be made.
              Default: 1
  -t, --threads=<N>
              Number of native threads.
              Default: 1
  -i, --input-file=<PATH>
              Path of a file with multiple URIs are separated by EOLs.
              This option will disable URIs getting from command-line.
              If '-' is given as <PATH>, URIs will be read from stdin.
              URIs are used  in this order for each  client.  All URIs
              are used, then  first URI is used and then  2nd URI, and
              so  on.  The  scheme, host  and port  in the  subsequent
              URIs, if present,  are ignored.  Those in  the first URI
              are used solely.  Definition of a base URI overrides all
              scheme, host or port values.
  -m, --max-concurrent-streams=<N>
              Max  concurrent  streams  to issue  per  session.   When
              http/1.1  is used,  this  specifies the  number of  HTTP
              pipelining requests in-flight.
              Default: 1
  -f, --max-frame-size=<SIZE>
              Maximum frame size that the local endpoint is willing to
              receive.
              Default: 16K
  -w, --window-bits=<N>
              Sets the stream level initial window size to (2**<N>)-1.
              For QUIC, <N> is capped to 26 (roughly 64MiB).
              Default: 30
  -W, --connection-window-bits=<N>
              Sets  the  connection  level   initial  window  size  to
              (2**<N>)-1.
              Default: 30
  -H, --header=<HEADER>
              Add/Override a header to the requests.
  --ciphers=<SUITE>
              Set  allowed cipher  list  for TLSv1.2  or earlier.   The
              format of the string is described in OpenSSL ciphers(1).
              Default: ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
  --tls13-ciphers=<SUITE>
              Set allowed cipher list for  TLSv1.3.  The format of the
              string is described in OpenSSL ciphers(1).
              Default: TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_CCM_SHA256
  -p, --no-tls-proto=<PROTOID>
              Specify ALPN identifier of the  protocol to be used when
              accessing http URI without SSL/TLS.
              Available protocols: h2c and http/1.1
              Default: h2c
  -d, --data=<PATH>
              Post FILE to  server.  The request method  is changed to
              POST.   For  http/1.1 connection,  if  -d  is used,  the
              maximum number of in-flight pipelined requests is set to
              1.
  -r, --rate=<N>
              Specifies  the  fixed  rate  at  which  connections  are
              created.   The   rate  must   be  a   positive  integer,
              representing the  number of  connections to be  made per
              rate period.   The maximum  number of connections  to be
              made  is  given  in  -c   option.   This  rate  will  be
              distributed among  threads as  evenly as  possible.  For
              example,  with   -t2  and   -r4,  each  thread   gets  2
              connections per period.  When the rate is 0, the program
              will run  as it  normally does, creating  connections at
              whatever variable rate it  wants.  The default value for
              this option is 0.  -r and -D are mutually exclusive.
  --rate-period=<DURATION>
              Specifies the time  period between creating connections.
              The period  must be a positive  number, representing the
              length of the period in time.  This option is ignored if
              the rate option is not used.  The default value for this
              option is 1s.
  -D, --duration=<DURATION>
              Specifies the main duration for the measurements in case
              of timing-based  benchmarking.  -D  and -r  are mutually
              exclusive.
  --warm-up-time=<DURATION>
              Specifies the  time  period  before  starting the actual
              measurements, in  case  of  timing-based benchmarking.
              Needs to provided along with -D option.
  -T, --connection-active-timeout=<DURATION>
              Specifies  the maximum  time that  h2load is  willing to
              keep a  connection open,  regardless of the  activity on
              said connection.  <DURATION> must be a positive integer,
              specifying the amount of time  to wait.  When no timeout
              value is  set (either  active or inactive),  h2load will
              keep  a  connection  open indefinitely,  waiting  for  a
              response.
  -N, --connection-inactivity-timeout=<DURATION>
              Specifies the amount  of time that h2load  is willing to
              wait to see activity  on a given connection.  <DURATION>
              must  be a  positive integer,  specifying the  amount of
              time  to wait.   When no  timeout value  is set  (either
              active or inactive), h2load  will keep a connection open
              indefinitely, waiting for a response.
  --timing-script-file=<PATH>
              Path of a file containing one or more lines separated by
              EOLs.  Each script line is composed of two tab-separated
              fields.  The first field represents the time offset from
              the start of execution, expressed as a positive value of
              milliseconds  with microsecond  resolution.  The  second
              field represents the URI.  This option will disable URIs
              getting from  command-line.  If '-' is  given as <PATH>,
              script lines will be read  from stdin.  Script lines are
              used in order for each client.   If -n is given, it must
              be less  than or  equal to the  number of  script lines,
              larger values are clamped to the number of script lines.
              If -n is not given,  the number of requests will default
              to the  number of  script lines.   The scheme,  host and
              port defined in  the first URI are  used solely.  Values
              contained  in  other  URIs,  if  present,  are  ignored.
              Definition of a  base URI overrides all  scheme, host or
              port   values.   --timing-script-file   and  --rps   are
              mutually exclusive.
  -B, --base-uri=(<URI>|unix:<PATH>)
              Specify URI from which the scheme, host and port will be
              used  for  all requests.   The  base  URI overrides  all
              values  defined either  at  the command  line or  inside
              input files.  If argument  starts with "unix:", then the
              rest  of the  argument will  be treated  as UNIX  domain
              socket path.   The connection is made  through that path
              instead of TCP.   In this case, scheme  is inferred from
              the first  URI appeared  in the  command line  or inside
              input files as usual.
  --npn-list=<LIST>
              Comma delimited list of  ALPN protocol identifier sorted
              in the  order of preference.  That  means most desirable
              protocol comes  first.  This  is used  in both  ALPN and
              NPN.  The parameter must be  delimited by a single comma
              only  and any  white spaces  are  treated as  a part  of
              protocol string.
              Default: h2,h2-16,h2-14,http/1.1
  --h1        Short        hand         for        --npn-list=http/1.1
              --no-tls-proto=http/1.1,    which   effectively    force
              http/1.1 for both http and https URI.
  --header-table-size=<SIZE>
              Specify decoder header table size.
              Default: 4K
  --encoder-header-table-size=<SIZE>
              Specify encoder header table size.  The decoder (server)
              specifies  the maximum  dynamic table  size it  accepts.
              Then the negotiated dynamic table size is the minimum of
              this option value and the value which server specified.
              Default: 4K
  --log-file=<PATH>
              Write per-request information to a file as tab-separated
              columns: start  time as  microseconds since  epoch; HTTP
              status code;  microseconds until end of  response.  More
              columns may be added later.  Rows are ordered by end-of-
              response  time when  using  one worker  thread, but  may
              appear slightly  out of order with  multiple threads due
              to buffering.  Status code is -1 for failed streams.
  --qlog-file-base=<PATH>
              Enable qlog output and specify base file name for qlogs.
              Qlog is emitted  for each connection.  For  a given base
              name   "base",    each   output   file    name   becomes
              "base.M.N.sqlog" where M is worker ID and N is client ID
              (e.g. "base.0.3.sqlog").  Only effective in QUIC runs.
  --connect-to=<HOST>[:<PORT>]
              Host and port to connect  instead of using the authority
              in <URI>.
  --rps=<N>   Specify request  per second for each  client.  --rps and
              --timing-script-file are mutually exclusive.
  --groups=<GROUPS>
              Specify the supported groups.
              Default: X25519:P-256:P-384:P-521
  --no-udp-gso
              Disable UDP GSO.
  --max-udp-payload-size=<SIZE>
              Specify the maximum outgoing UDP datagram payload size.
  --ktls      Enable ktls.
  -v, --verbose
              Output debug information.
  --version   Display version information and exit.
  -h, --help  Display this help and exit.

--

  The <SIZE> argument is an integer and an optional unit (e.g., 10K is
  10 * 1024).  Units are K, M and G (powers of 1024).

  The <DURATION> argument is an integer and an optional unit (e.g., 1s
  is 1 second and 500ms is 500 milliseconds).  Units are h, m, s or ms
  (hours, minutes, seconds and milliseconds, respectively).  If a unit
  is omitted, a second is used as unit.
```

```
docker run --rm -it nghttp3 nghttp --help
Usage: nghttp [OPTIONS]... <URI>...
HTTP/2 client

  <URI>       Specify URI to access.
Options:
  -v, --verbose
              Print   debug   information   such  as   reception   and
              transmission of frames and name/value pairs.  Specifying
              this option multiple times increases verbosity.
  -n, --null-out
              Discard downloaded data.
  -O, --remote-name
              Save  download  data  in  the  current  directory.   The
              filename is  derived from  URI.  If  URI ends  with '/',
              'index.html'  is used  as a  filename.  Not  implemented
              yet.
  -t, --timeout=<DURATION>
              Timeout each request after <DURATION>.  Set 0 to disable
              timeout.
  -w, --window-bits=<N>
              Sets the stream level initial window size to 2**<N>-1.
  -W, --connection-window-bits=<N>
              Sets  the  connection  level   initial  window  size  to
              2**<N>-1.
  -a, --get-assets
              Download assets  such as stylesheets, images  and script
              files linked  from the downloaded resource.   Only links
              whose  origins are  the same  with the  linking resource
              will be downloaded.   nghttp prioritizes resources using
              HTTP/2 dependency  based priority.  The  priority order,
              from highest to lowest,  is html itself, css, javascript
              and images.
  -s, --stat  Print statistics.
  -H, --header=<HEADER>
              Add a header to the requests.  Example: -H':method: PUT'
  --trailer=<HEADER>
              Add a trailer header to the requests.  <HEADER> must not
              include pseudo header field  (header field name starting
              with ':').  To  send trailer, one must use  -d option to
              send request body.  Example: --trailer 'foo: bar'.
  --cert=<CERT>
              Use  the specified  client certificate  file.  The  file
              must be in PEM format.
  --key=<KEY> Use the  client private key  file.  The file must  be in
              PEM format.
  -d, --data=<PATH>
              Post FILE to server. If '-'  is given, data will be read
              from stdin.
  -m, --multiply=<N>
              Request each URI <N> times.  By default, same URI is not
              requested twice.  This option disables it too.
  -u, --upgrade
              Perform HTTP Upgrade for HTTP/2.  This option is ignored
              if the request URI has https scheme.  If -d is used, the
              HTTP upgrade request is performed with OPTIONS method.
  -p, --weight=<WEIGHT>
              Sets  weight of  given  URI.  This  option  can be  used
              multiple times, and  N-th -p option sets  weight of N-th
              URI in the command line.  If  the number of -p option is
              less than the number of URI, the last -p option value is
              repeated.  If there is no -p option, default weight, 16,
              is assumed.  The valid value range is
              [1, 256], inclusive.
  -M, --peer-max-concurrent-streams=<N>
              Use  <N>  as  SETTINGS_MAX_CONCURRENT_STREAMS  value  of
              remote endpoint as if it  is received in SETTINGS frame.
              Default: 100
  -c, --header-table-size=<SIZE>
              Specify decoder  header table  size.  If this  option is
              used  multiple times,  and the  minimum value  among the
              given values except  for last one is  strictly less than
              the last  value, that minimum  value is set  in SETTINGS
              frame  payload  before  the   last  value,  to  simulate
              multiple header table size change.
  --encoder-header-table-size=<SIZE>
              Specify encoder header table size.  The decoder (server)
              specifies  the maximum  dynamic table  size it  accepts.
              Then the negotiated dynamic table size is the minimum of
              this option value and the value which server specified.
  -b, --padding=<N>
              Add at  most <N>  bytes to a  frame payload  as padding.
              Specify 0 to disable padding.
  -r, --har=<PATH>
              Output HTTP  transactions <PATH> in HAR  format.  If '-'
              is given, data is written to stdout.
  --color     Force colored log output.
  --continuation
              Send large header to test CONTINUATION.
  --no-content-length
              Don't send content-length header field.
  --no-dep    Don't send dependency based priority hint to server.
  --hexdump   Display the  incoming traffic in  hexadecimal (Canonical
              hex+ASCII display).  If SSL/TLS  is used, decrypted data
              are used.
  --no-push   Disable server push.
  --max-concurrent-streams=<N>
              The  number of  concurrent  pushed  streams this  client
              accepts.
  --expect-continue
              Perform an Expect/Continue handshake:  wait to send DATA
              (up to  a short  timeout)  until the server sends  a 100
              Continue interim response. This option is ignored unless
              combined with the -d option.
  -y, --no-verify-peer
              Suppress  warning  on  server  certificate  verification
              failure.
  --ktls      Enable ktls.
  --no-rfc7540-pri
              Disable RFC7540 priorities.
  --version   Display version information and exit.
  -h, --help  Display this help and exit.

--

  The <SIZE> argument is an integer and an optional unit (e.g., 10K is
  10 * 1024).  Units are K, M and G (powers of 1024).

  The <DURATION> argument is an integer and an optional unit (e.g., 1s
  is 1 second and 500ms is 500 milliseconds).  Units are h, m, s or ms
  (hours, minutes, seconds and milliseconds, respectively).  If a unit
  is omitted, a second is used as unit.
```