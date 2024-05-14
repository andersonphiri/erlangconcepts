%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 10:17
%%%-------------------------------------------------------------------
-module(user_default).
-author("phiri").

%% API
%% -export([]).
-compile(export_all).

cls() ->
  _ = io:format(os:cmd(clear)).
clear() -> cls().

hello() -> "hello anderson wsl.".