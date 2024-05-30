%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. May 2024 09:43
%%%------------------------------------------------------------------- 
-module(ets_test).
-author("phiri").
-export([start/0]).

start() -> 
    lists:foreach(fun test_ets/1, [set, ordered_set, bag, duplicate_bag]).

test_ets(Mode) -> 
    Tid = ets:new(test_table, [Mode]),
    ets:insert(Tid, {a, 1}) ,
    ets:insert(Tid, {b, 2}) ,
    ets:insert(Tid, {a, 1}) ,
    ets:insert(Tid, {a, 3}) ,
    ListOfItems = ets:tab2list(Tid),
    io:format("~-13w => ~p~n", [Mode,ListOfItems]),
    ets:delete(Tid).
