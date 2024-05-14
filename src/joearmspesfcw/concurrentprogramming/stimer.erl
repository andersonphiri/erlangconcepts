%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 14:28
%%%-------------------------------------------------------------------
-module(stimer).
-author("phiri").

%% API
-export([start/2, cancel/1]).


start(Time, Fun) -> spawn(fun() -> timer(Time, Fun) end ).
cancel(Pid) -> Pid ! cancel .
timer(Time, Fun) ->
  receive
    cancel ->
      void
  after Time ->
    Fun()
  end.



