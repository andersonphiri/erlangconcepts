%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. May 2024 17:33
%%%-------------------------------------------------------------------
-module(types1).
-author("phiri").

%% API
-export([]).

myand1(true, true) -> true;
myand1(false, _) -> false;
myand1(_, false) -> false.

