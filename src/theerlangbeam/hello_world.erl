%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. May 2024 08:38
%%%-------------------------------------------------------------------
-module(hello_world).
-author("phiri").
-include("world.hrl").
%% API
-export([hello/0]).

hello() -> ?HELLO.