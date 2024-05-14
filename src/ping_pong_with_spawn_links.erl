%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Mar 2024 03:50
%%%-------------------------------------------------------------------
-module(ping_pong_with_spawn_links).
-author("phiri").

%% API
-export([start/1, ping/2 , pong/0]).

ping(N, Pong_Pid) ->
  link(Pong_Pid),
  ping_aux(N, Pong_Pid).


ping_aux(0, _) ->
  exit(ping);

ping_aux(N,Pong_Pid) ->
  Pong_Pid ! {ping, self()} ,
  receive
    pong ->
      io:format("Ping received Pong ~p th time ~n," ,[N])
  end,
  ping_aux(N - 1, Pong_Pid).

pong() ->
  process_flag(trap_exit, true),
  pong_aux().


pong_aux() ->
  receive
    {ping, Ping_Pid} ->
      io:format("~p>>> pong received ping from ~p~n", [self(), Ping_Pid]),
      Ping_Pid ! pong,
      pong_aux();
    {'EXIT', From, Reason} ->
      io:format("~p>>> pong, exiting, got ~p~n", [self(), {'Exit', From, Reason}])
  end.

start({ping_node, Ping_Node, number_of_times, Number_Of_Times }) ->
  Pong_Pid = spawn(ping_pong_with_spawn_links, pong, []),
  spawn(Ping_Node,ping_pong_with_spawn_links, ping, [Number_Of_Times, Pong_Pid]).

