%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. May 2024 08:15
%%%-------------------------------------------------------------------
-module(a).
-author("phiri").

%% API

-compile(export_all).

%% API

start(Tag) ->
  spawn(fun() -> loop(Tag) end).

loop(Tag) ->
  sleep(),
  Val = b:x(),
  io:format("Vsn2 (~p) b:x() = ~p~n", [Tag, Val]),
  loop(Tag).

sleep() ->
  receive
  after 3000 -> true
  end.

%% read the purge_module for mr