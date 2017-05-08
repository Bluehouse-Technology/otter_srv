%%%-------------------------------------------------------------------
%%% Licensed to the Apache Software Foundation (ASF) under one
%%% or more contributor license agreements.  See the NOTICE file
%%% distributed with this work for additional information
%%% regarding copyright ownership.  The ASF licenses this file
%%% to you under the Apache License, Version 2.0 (the
%%% "License"); you may not use this file except in compliance
%%% with the License.  You may obtain a copy of the License at
%%%
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%%
%%%-------------------------------------------------------------------

-module(otter_srv_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    {ok, { {one_for_all, 0, 1}, [cowboy_spec()]} }.


cowboy_spec() ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/[...]", otter_srv_zipkin_handler, []}
        ]}
    ]),
    ListenPort = otter_srv_config:read(server_zipkin_port, 9411),
    ranch:child_spec(
        otter_srv_zipkin,
        100,
        ranch_tcp,
        [
            {port, ListenPort},
            {max_connections, 100},
            {backlog, 1024}
        ],
        cowboy_protocol,
        [{env, [{dispatch, Dispatch}]}]
    ).
