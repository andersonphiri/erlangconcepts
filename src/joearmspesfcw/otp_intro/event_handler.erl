%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2024 8:56 PM
%%%-------------------------------------------------------------------
-module(event_handler).
-author("chikuse2").

%% API
-export([make/1, add_handler/2, event/2]).

make(Name) ->
  register(Name, spawn(fun() -> my_handler(fun no_op/1) end) ).


add_handler(Name, Fun) -> Name ! {add, Fun}.

%% generate an event
event(Name, X) -> Name ! {event, X}.

my_handler(Fun) ->
  receive
    {add, Fun1} ->
      my_handler(Fun1);
    {event, Any} ->
      catch(Fun(Any)),
      my_handler(Fun)
  end.

no_op(_) -> void.