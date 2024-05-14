%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2024 15:21
%%%-------------------------------------------------------------------
-module(useless).
-author("phiri").
-import(io, [format/1, format/2, format/3]).
%% API
-export([]).

add(A,B) ->
  A + B.

hello() ->
  format("hellow learn you some erlang for good, ~p, ~n", ["for sho"]).


greet_and_add_two(X) ->
  hello(),
  add(2, X),
  ok.