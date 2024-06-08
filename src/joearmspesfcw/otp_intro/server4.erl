%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%% server4 provides both hot reload and transactional
%%% @end
%%% Created : 09. Jun 2024 12:25 AM
%%%-------------------------------------------------------------------
-module(server4).
-author("chikuse2").

%% API
-export([]).


start(Name, Mod) ->
  register(Name, spawn(fun() ->  loop(Name,Mod,Mod:init()) end)).


swap_code(Name, Mod) -> rpc(Name,{swap_code, Mod}).

rpc(Name,Request) ->
  Name ! {self(), Request},
  receive
    {Name, crash} ->
      io:format("i have received a crash  message"),
      exit(rpc);
    {Name, Response} -> Response
  end.

loop(Name, Mod, OldState) ->
  receive
    {From, {swap_code, NewCallbackMod}} ->
      From ! {Name,ack},
      loop(Name, NewCallbackMod, OldState);
    {From, Request} ->
      try Mod:handle(Request,OldState) of
        {Response, NewState} ->
          From ! {Name, ok, Response} ,
          loop(Name,Mod,NewState)

      catch
        _:Why  ->
          log_the_error(Name,Request,Why),
          From ! {Name, crash} ,
          loop(Name, Mod, OldState)
      end
  end.

log_the_error(Name, Requwest, Why) ->
  io:format("SERVER ~p request ~p ~n"
  "caused exception ~p~n",
    [Name, Requwest, Why]).