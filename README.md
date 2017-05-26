# OTTER Server

OpenTracing server application. It listens on HTTP and accepts spans encoded
with the OpenZipkin Thrift binary protocol. In the current stage it only
exposes a callback which is called with each span received. It could be
used as a skeleton for processing OpenTracing spans from different systems.
For more information on OpenTracing and [otter](https://github.com/Bluehouse-Technology/otter),
check the [otter](https://github.com/Bluehouse-Technology/otter) documentation.

## Build

OTTER Server uses [rebar3](http://www.rebar3.org) as build tool. It can be
built with:

```
    rebar3 compile
```

However most likely you'll want to add it to your project in your build
environment.


## Dependencies


[otter_lib](https://github.com/Bluehouse-Technology/otter_lib) Common
library functions shared for [otter](https://github.com/Bluehouse-Technology/otter) and otter_srv

[cowboy](https://github.com/ninenines/cowboy) web server.

## Functionality
The server is started up during otter application start. There are 2 configuration
parameters in the otter_srv application environment.

**server_zipkin_callback** configuration parameter should be set to the
```{Module, Function}``` tuple. And the listening port can be specified
with **server_zipkin_port** (defaults to 9411 if not defined). When spans
are received on the server, they are decoded to otter ```#span{}``` record
(see the otter or otter_lib applications for more details) and individually
handed to the specified callback. There is a stub/example callback module
(otter_srv_span_cb.erl) in the application. All the string types in the span
are decoded to ```binary()```.

The spans can be submitted to any URI path. The path is ignored by the
server and the server always responds with HTTP response code 202 in the
current implementation.

Example server configuration

```erlang
    ...
    {server_zipkin_callback, {otter_srv_span_cb, handle}},
    {server_zipkin_port, 19411},
    ...
```
