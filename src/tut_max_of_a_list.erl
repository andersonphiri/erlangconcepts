%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2024 12:11
%%%-------------------------------------------------------------------
-module(tut_max_of_a_list).
-author("phiri").

%% API
-export([list_max/1, reverse_list/1, get_last_of_list/1]).

list_max([Head| Tail]) ->
  list_max(Tail, Head).

list_max([], Res) ->
  Res;
list_max([Head | Tail], Accum) when Head > Accum ->
  list_max(Tail, Head);
list_max([_ | Tail], Accum) ->
  list_max(Tail, Accum).

%% L1 = [madrid | Tail] append head



reverse_list(List) ->
  reverse_list(List, []).

reverse_list([], Accum) ->
  Accum;
reverse_list([Head | Tail], Accum ) ->
  reverse_list(Tail, [Head | Accum]).

get_last_of_list(List) ->
  get_last_of_list(List,[]).

get_last_of_list([], Accum) ->
  Accum;
get_last_of_list([Head | Tail], _ ) ->
  get_last_of_list(Tail, Head).


