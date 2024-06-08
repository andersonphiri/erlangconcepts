%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 04 Jun 2024 by anderson phiri <andersonp@generictechnologie.com>
-module(server1).
-export([start/2, rpc/2]).

start(Name, Mod) -> 
    register(Name, spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Request) -> 
    Name ! {self(), Request},
    receive
        {Name,Response} ->  Response
    end.

loop(Name,Mod,State) -> 
    receive
        {From, Request} ->
            {Response, State1} = Mod:handle(Request,State),
            From ! {Name, Response},
            loop(Name, Mod, State1)
    end.
