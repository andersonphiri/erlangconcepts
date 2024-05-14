%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. May 2024 15:50
%%%-------------------------------------------------------------------
-module(key_value_server).
-author("phiri").

%% API
-export([start/0, store/2, lookup/1]).
%% -spec key_value_server:start() -> true.
%% -spec key_value_server:store(Key,Value) -> true.
%% -spec key_value_server:lookup(Key) -> {ok, Value} | undefined.

start() -> register(kvs, spawn(fun() -> loop() end)).


store(Key, Value) -> rpc({store, Key, Value}).
lookup(Key) -> rpc({lookup, Key}).

rpc(Query) ->
  kvs ! {self(), Query},
  receive
    {kvs, Reply} -> Reply
  end.

loop() ->
  receive
    {From, {store, Key, Value}} ->
      put(Key, Value),
      From ! {kvs, true},
      loop();
    {From, {lookup, Key}} ->
      From ! {kvs, get(Key)},
      loop()
  end.


%% pp: 215