%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Feb 2024 11:48
%%%-------------------------------------------------------------------
-module(concur_processes).
-author("phiri").

%% API
-export([say_something/2, start/0]).

say_something(_, 0) ->
  done;
say_something(What, Times) ->
  io:format("~p~n",[What]),
  say_something(What, Times - 1).

start() ->
  spawn(concur_processes,say_something, [hello, 3]),
  spawn(concur_processes,say_something, [goodbye, 3]).
