%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%% server5 waits and does nothing until you tell it what to become
%%% Pid = server5:start().
%%% <0.86.0>
%%% Pid ! {become, fun my_fac_server:loop/0}.
%%% {become,fun my_fac_server:loop/0}
%%% Pid ! hello
%%%   .
%%% unknown request type: {hello}
%%% hello
%%% Pid ! {fact, 30}.
%%% unknown request type: {{fact,30}}
%%% {fact,30}
%%% server5:rpc(Pid, {fact, 30}).
%%% 265252859812191058636308480000000
%%% @end
%%% Created : 09. Jun 2024 12:32 AM
%%%-------------------------------------------------------------------
-module(server5).
-author("chikuse2").

%% API
-export([start/0,rpc/2]).

start() -> spawn(fun() -> wait() end ).

wait() ->
  receive
    {become, Func} -> Func()
  end.

rpc(Pid, Q) ->
  Pid ! {self(), Q},
  receive
    {Pid, Reply} -> Reply
  end.

