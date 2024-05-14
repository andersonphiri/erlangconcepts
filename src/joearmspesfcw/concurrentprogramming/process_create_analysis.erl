%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 13:32
%%%-------------------------------------------------------------------
-module(process_create_analysis).
-author("phiri").

%% API
-export([max/1]).

%% Note: to increase the maximum number of allowed processes start erl with +P flag: erl +P 3000000

max(N) ->
  Max = erlang:system_info(process_limit),
  io:format("Maximum allowed processs: ~p~n",[Max]),
  statistics(runtime),
  statistics(wall_clock),
  L = for(1, N, fun() -> spawn(fun() -> wait() end) end ),
  {_, Time1} = statistics(runtime),
  {_, TIme2} = statistics(wall_clock) ,
  lists:foreach(fun(Pid) -> Pid ! die end , L),
  U1 = Time1 * 1000 / N ,
  U2 = TIme2 * 1000 / N ,
  io:format("Process spawn time=~p (~p) microseconds~n",[U1, U2]).


wait() ->
  receive
    die -> void
  end.

for(N,N,F) -> [F()];
for(I,N,F) -> [F() | for(I + 1, N, F)].


