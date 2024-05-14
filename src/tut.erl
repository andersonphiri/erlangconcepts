%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2024 09:18
%%%-------------------------------------------------------------------
-module(tut).
-author("phiri").

%% API
-export([double/1, fact/1 , convert/2, convert_length/1, list_length/1, list_size/1]).

double(X) ->
  2 * X.

fact(1) ->
  1;
fact(N) ->
  N * fact(N - 1).

%% atoms

convert(M, inch) ->
  M / 2.54;
convert(N, centimeter) ->
  N * 2.54.

%% grouping things together nicely
convert_length({centimeter, X}) ->
  {inch, X / 2.54 };
convert_length({inch, Y}) ->
  {centimeter, Y * 2.54 }.

%% length of a list
list_length([]) ->
  0;
list_length([_ | Tail]) ->
  1 + list_length(Tail).

list_length_accum([], Accum) ->
  Accum;
list_length_accum([_ | Rest], Accum) ->
  list_length_accum(Rest, 1 + Accum).

list_size([]) ->
  0;
list_size([Head | Tail]) ->
  list_length_accum([Head | Tail], 0).
