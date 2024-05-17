%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. May 2024 09:55
%%%-------------------------------------------------------------------
-module(dist_demo).
-author("phiri").

%% API
-export([rpc/4, start/1]).


start(Node) ->
  spawn(Node, fun() -> loop() end).

rpc(Pid, M,F,A) ->
  Pid ! {rpc, self(), M,F,A},
  receive
    {Pid, Response} ->
      io:format("~p has sent a response of: ~p~n",[Pid, Response])
  end.

loop() ->
  receive
    {rpc, Pid, M,F,A} ->
      Pid ! {self(), (catch apply(M,F,A))},
      loop()
  end.

%% dist_demo:rpc(PidRemote,erlang,node,[]).
%% PidRemote2 = dist_demo:rpc(PidRemote,key_value_server,start,[]).

