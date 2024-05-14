%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 15:25
%%%-------------------------------------------------------------------
-module(concurrent_program_template).
-author("phiri").

%% API
-compile(export_all).
start() -> spawn(?MODULE, loop, []).


rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} ->
      io:format("sende pid: ~w~n",[Pid]),
      Response
  end.


loop() ->
  receive
    Any ->
      io:format("Received: ~p~n",[Any]),
      loop()
  end.