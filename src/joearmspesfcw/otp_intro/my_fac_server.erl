%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Jun 2024 12:45 AM
%%%-------------------------------------------------------------------
-module(my_fac_server).
-author("chikuse2").

%% API
-export([loop/0]).


loop() ->
  receive
    {From,{fact, N} } ->
      From ! {self(), fac(N)},
      loop();
    {become, Something} -> Something();
    Other ->
      io:format("unknown request type: {~p}~n",[Other]),
      loop()

  end.

fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N -1).



