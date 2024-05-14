%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 4月 2024 11:00
%%%-------------------------------------------------------------------
-module(shop).
-author("phiri").

%% API
-export([cost/1]).

cost(Fruit) ->
  case Fruit of
    oranges -> 5;
    newspaper -> 8;
    apples -> 2;
    pears -> 9;
    milk -> 7
  end.