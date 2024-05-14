%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Feb 2024 08:56
%%%-------------------------------------------------------------------
-module(concur_distributed_ping_pong_on_ping).
-author("phiri").

%% HOW TO RUN: start ping node, next start pong node, join nodes, the from pong shell run: concur_distributed_ping_pong_on_ping:start('ping@ping_node_ip')
%% API
-export([start/1, ping/2, pong/0]).

ping(0, Pong_Node) ->
  {pong, Pong_Node} ! finished,
  io:format("ping finished~n", []);

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
    {ping, Ping_Pid} ->
      io:format("Pong received ping~n", []),
      Ping_Pid ! pong,
      pong()
  end.

start(Ping_Node) ->
  register(pong, spawn(concur_distributed_ping_pong_on_ping, pong, [])),
  spawn(Ping_Node, concur_distributed_ping_pong_on_ping, ping, [3, node()]).
