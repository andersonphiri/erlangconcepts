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
-on_load(execute_on_load/0).
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

execute_on_load() ->
  io:format("you are loading module ~p. This module uses process dictionary~n",[?MODULE_STRING]),
  io:format("from anderson the author, I wish you a happy usage~n"),
  ok.

%% erl -name 'ubuntu_kvs_1@172.31.227.3'
%% start the server: erl -name 'ubuntu_kvs_1@172.31.227.3' -setcookie abc
%% start client on a different machine: erl -name 'windows_client_erl@192.168.100.68' -setcookie abc
%% erpc:call(ubuntu_kvs_1@172.31.227.3,key_value_server,store,[weather,toocold]).
%% pp: 215