%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. May 2024 09:05
%%%-------------------------------------------------------------------
-module(json_parser).
-author("phiri").

%% API
-export([parse_transform/2]).

parse_transform(AST,_Options) ->
  io:format("the abstract syntax tree is:~n~p~n",[AST]),
  AST.


