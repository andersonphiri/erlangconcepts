%%% @author Anderson Phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, Anderson Phiri
%%% @doc 
%%%
%%% @end
%%% Created : 23 Jun 2024 by Anderson Phiri <andersonp@generictechnologie.com>
-module(counter).
-export([bump/2, read/1]).


bump(N, {counter, K}) -> {counter, N + K}.
read({counter, N}) -> N.

%%% ppp419