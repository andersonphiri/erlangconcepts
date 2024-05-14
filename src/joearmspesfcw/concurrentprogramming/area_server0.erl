%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 11:45
%%%-------------------------------------------------------------------
-module(area_server0).
-author("phiri").

%% API
-export([loop/0]).

loop() ->
  receive
    {rectangle, Length, Width} ->
      io:format("The area of a rectangle with the length of ~w and width of ~w is: ~w~n",[Length, Width, Length * Width]),
      loop();
    {square, Side} ->
      io:format("The area of square with side ~w is: ~w~n",[Side, Side *Side]),
      loop()
  end.
