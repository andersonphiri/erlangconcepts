%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Feb 2024 11:56
%%%-------------------------------------------------------------------
-module(concur_message_passing).
-author("phiri").

%% API
-export([ping/1, pong/0, start/0]).

ping(0) ->
  pong ! finished,
  io:format("ping finished~n", []);

ping(N) ->
  pong ! {ping, self()},
  receive
    pong ->
      io:format("ping received pong~n",[])
  end,
  ping(N - 1).

pong() ->
  receive
    finished ->
      %% process finished here
      io:format("Pong Finished~n", []);
    {ping, Ping_PID} ->
      % process pong here
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.

start() ->
  %% Pong_PID = spawn(concur_message_passing, pong, []),
  register(pong, spawn(concur_message_passing, pong, [])),
  spawn(concur_message_passing, ping, [3]).