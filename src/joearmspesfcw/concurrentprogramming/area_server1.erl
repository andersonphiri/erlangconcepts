%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 12:00
%%%-------------------------------------------------------------------
-module(area_server1).
-author("phiri").

%% API
-export([loop/0, rpc/2]).


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