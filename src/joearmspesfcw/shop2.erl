%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 4月 2024 11:12
%%%-------------------------------------------------------------------
-module(shop2).
-author("phiri").

%% API
-export([]).

test_funs() ->
  TempConverter = fun({celcius, Celcius}) -> {fahrenheight, 32 + Celcius * 9 / 5} ;
                    ({fahrenheight, Fahrenheight}) -> {celcius, (Fahrenheight - 32) * 5 / 9}
                  end,
  ok.

afun_that_returns_a_fun() ->
  MakeTest = fun(L) -> (fun(X) -> lists:member(X,L) end) end ,
  %%% Fruits = [apple, pear, orrange].
  %%% IsFruit = MakeTest(Fruits).
  %%% IsFruit(apple). returns true
  MakeTest.