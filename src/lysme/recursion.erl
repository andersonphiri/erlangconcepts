%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Mar 2024 02:29
%%%-------------------------------------------------------------------
-module(recursion).
-author("phiri").

%% API
-export([]).

bestest_qsort([], Acc) -> Acc;
bestest_qsort([Pivot|Rest], Acc) ->
  bestest_partition(Pivot, Rest, {[], [Pivot], []}, Acc).

bestest_partition(_, [], {Smaller, Equal, Larger}, Acc) ->
  bestest_qsort(Smaller, Equal ++ bestest_qsort(Larger, Acc));
bestest_partition(Pivot, [H|T], {Smaller, Equal, Larger}, Acc) ->
  if H < Pivot ->
    bestest_partition(Pivot, T, {[H|Smaller], Equal, Larger}, Acc);
    H > Pivot ->
      bestest_partition(Pivot, T, {Smaller, Equal, [H|Larger]}, Acc);
    H == Pivot ->
      bestest_partition(Pivot, T, {Smaller, [H|Equal], Larger}, Acc)
  end.

