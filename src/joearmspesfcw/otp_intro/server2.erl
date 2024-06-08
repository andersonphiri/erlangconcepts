%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc server2
%%% server2 provides transactional code execution. if something for rpc, it
%%% will run with previous know state
%%% @end
%%% Created : 08. Jun 2024 10:18PM
%%%-------------------------------------------------------------------
-module(server2).
-author("chikuse2").

%% API
-export([start/2, rpc/2]).

start(Name, Mod) ->
  register(Name, spawn(fun() ->  loop(Name,Mod,Mod:init()) end)).

rpc(Name, Requwest) ->
  Name ! { self(), Requwest},
  receive
    {Name, crash} ->
      io:format("i have received a crash  message"),
      exit(rpc);
    {Name, ok, Response} -> Response
  end.

loop(Name, Mod, OldState) ->
  receive
    {From, Requwest} ->
      try Mod:handle(Requwest,OldState) of
        {Response, NewState} ->
          From ! {Name, ok, Response} ,
          loop(Name,Mod,NewState)

      catch
          _:Why  ->
            log_the_error(Name,Requwest,Why),
            From ! {Name, crash} ,
            loop(Name, Mod, OldState)
      end
  end.

log_the_error(Name, Requwest, Why) ->
  io:format("SERVER ~p request ~p ~n"
  "caused exception ~p~n",
  [Name, Requwest, Why]).

