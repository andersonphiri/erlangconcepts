%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 4月 2024 11:03
%%%-------------------------------------------------------------------
-module(shop1).
-author("phiri").
%% -include("shop.erl").
%% API
-export([total/1, total_v2/1]).

total([ {Fruit, Count} | T]) ->
  shop:cost(Fruit) * Count + total(T);

total([]) -> 0.

total_v2([]) -> 0;
total_v2(Items) ->
  lists:sum([shop:cost(A) * B || {A,B} <- Items]).