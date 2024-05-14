%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Feb 2024 14:08
%%%-------------------------------------------------------------------
-module(concur_distributed_ping_pong).
-author("phiri").

%% API
-export([start_ping/1, start_pong/0, pong/0, ping/2]).
ping(0, Pong_Node) ->
  {pong, Pong_Node} ! finished,
  io:format("pong finished~n", []);

ping(N, Pong_Node) ->
  {pong, Pong_Node} ! {ping, self()},
  receive
    pong ->
      io:format("Ping received pong~n", [])
  end,
  ping(N - 1, Pong_Node).

pong() ->
  receive
    finished ->
      io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.

start_pong() ->
  register(pong, spawn(concur_distributed_ping_pong, pong, [])).

start_ping(Pong_Node) ->
  spawn(concur_distributed_ping_pong, ping, [3, Pong_Node]).

