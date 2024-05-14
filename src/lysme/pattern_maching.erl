%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2024 17:10
%%%-------------------------------------------------------------------
-module(pattern_maching).
-author("phiri").

%% API
-export([]).


beach(Temperature) ->
  case Temperature of
    {celcius, N} when N >= 293, N =< 318 -> 'favourable';
    {kelvin, N} when N >= 293, N =< 318 -> 'scientifically favourable';
    {fahreheit, N} when N >= 68, N =< 113 ->
      'favourable in the house';
    _ ->
      'avoid beach'
  end.

%%%% https://learnyousomeerlang.com/types-or-lack-thereof