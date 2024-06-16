%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2024 10:37 PM
%%%-------------------------------------------------------------------
-module(motor_controller).
-author("chikuse2").

%% API
-export([add_event_handler/0]).

add_event_handler() ->
  event_handler:add_handler(errors, fun controller/1).

controller(too_hot) ->
  io:format("Turn off the motor ~n");
controller(X) ->
  io:format("~w ignored the event: ~p~n",[?MODULE,X]).

%% pp 387
%% erl -boot start_sasl
