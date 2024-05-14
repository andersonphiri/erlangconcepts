%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2024 14:14
%%%-------------------------------------------------------------------
-module(maps_or_disctionaries).
-author("phiri").

%% API
-export([]).


map_create() ->
  #{b => 2, a => 5}.

map_with_nonatomic_keys() ->
  #{{wife, fred} => "martha", {age, fred} => 36, {likes, jim} => [oranges, bananas, soccer] }.

%% read keys from map
read_key(MyMap, Key) -> maps:get(Key, MyMap).

upsert_map(MyMap, Key, Value) -> MyMap#{Key => Value}. %% this operation always succeeds even the key does not exist
update_only_if_key_exists(MyMap, Key, Value) -> MyMap#{Key := Value}. %% will fail if Key does not exists

count_chars(Str) -> count_chars(Str, maps:new()).

count_chars([H | T], #{H => N} = X) ->
  count_chars(T,X#{H := N + 1} );
count_chars([H|T], X) ->
  count_chars(T, X#{H => 1});
count_chars([], X) -> X.