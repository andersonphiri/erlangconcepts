%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 12:18
%%%-------------------------------------------------------------------
-module(area_server_final).
-author("phiri").

%% API
-export([start_server/0, area/2, loop/0]).

start_server() -> spawn(area_server_final, loop, []).

area(Pid, What) ->
  rpc(Pid, What).

rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Calculations} ->
      io:format("server pid: ~w~n",[Pid]),
      Calculations
  end.


loop() ->
  receive
    {From,{rectangle, Length, Width}} ->
      From ! { self(), Length * Width },
      loop();
    {From, {circle, Radius}} ->
      From ! { self(), math:pi() * Radius * Radius } ,
      loop();
    {From, Other} ->
      From ! {self(), {error_unhandled_message_type, Other}},
      loop()
  end.
