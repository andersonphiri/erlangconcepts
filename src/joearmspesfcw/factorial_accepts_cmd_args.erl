%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. May 2024 16:31
%%%-------------------------------------------------------------------
-module(factorial_accepts_cmd_args).
-author("phiri").

%% API
-export([main/1]).
main([A]) ->
  I = list_to_integer(atom_to_list(A)),
  F = fact(I),
  io:format("factorial of ~w  = ~w ~n", [I, F]),
  init:stop().


fact(0) -> 1;
fact(N) -> N * fact(N - 1).


%% how to execute this program:
%% erlc factorial_accepts_cmd_args.erl
%% erl -noshell -s factorial_accepts_cmd_args main 25