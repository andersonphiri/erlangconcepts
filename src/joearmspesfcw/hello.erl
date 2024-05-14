%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2024 13:46
%%%-------------------------------------------------------------------
-module(hello).
-author("phiri").

%% API
-export([start/0]).
-define(DWORD, 32/unsigned-little-integer).
-define(LONG, 32/unsigned-little-integer).
-define(WORD, 16/unsigned-little-integer).
-define(BYTE, 8/unsigned-little-integer).


%%% erlc hello.rl
%%% erl -noshell -s hello start -s init stop
start () ->
  io:format("hellooh world~n",[]).