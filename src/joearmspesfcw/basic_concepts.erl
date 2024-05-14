%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 4月 2024 08:53
%%%-------------------------------------------------------------------
-module(basic_concepts).
-author("phiri").

%% API
-export([division/0, creating_tuples/0]).

%%% then you can run your compilation as:
%%% erlc -D

division() ->
  io:format("~p/~p = ~p~n", [4,2,4/2]), %% 2.0
  io:format("~p div ~p = ~p~n", [4,2,4 div 2]). %% 2.0

creating_tuples() ->
  T1 = {fname, anderson},
  T2 = {lname, phiri},
  io:format("~p ~n ~p ~n", [T1,T2]).





