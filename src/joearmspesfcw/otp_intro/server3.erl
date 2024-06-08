%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jun 2024 11:27 PM
%%%-------------------------------------------------------------------
-module(server3).
-author("chikuse2").

%% API
-export([start/2, rpc/2, swap_code/2]).

start(Name, Mod) ->
  register(Name, spawn(fun() ->  loop(Name,Mod,Mod:init()) end)).


swap_code(Name, Mod) -> rpc(Name,{swap_code, Mod}).

rpc(Name,Request) ->
  Name ! {self(), Request},
  receive
    {Name, Response} -> Response
  end.

loop(Name, Mod, OldState) ->
  receive
    {From, {swap_code, NewCallbackMod}} ->
      From ! {Name,ack},
      loop(Name, NewCallbackMod, OldState);
    {From, Request} ->
      {Response, NewState} = Mod:handle(Request, OldState),
      From ! {Name, Response},
      loop(Name,Mod, NewState)
  end.


