%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2024 11:34
%%%-------------------------------------------------------------------
-module(tut_io).
-author("phiri").

%% API
-export([format_temps/1 , format_temps/2, test_if/2 , convert_length/1]).

format_temps([]) ->
  ok;
format_temps([City | Rest]) ->
  print_temp(convert_to_celsius(City)),
  format_temps(Rest).

convert_to_celsius({Name, {c, Temp}}) ->
  {Name, {c, Temp}};
convert_to_celsius({Name, {f, Temp}}) ->
  {Name, {c, (Temp - 32) * 5 / 9}}.


convert_length(Length) ->
  case Length of  {centimeter, X} ->
    {inch , X / 2.54};
    {inch, Y} ->
      {centimeter, Y * 2.54}
  end.


print_temp({Name, {c, Temp}}) ->
  io:format("~-15w ~w c~n", [Name, Temp]).

%% more structured approach

format_temps(structured, List_of_Cities) ->
  ConvertedList = convert_list_to_c_with_fun(List_of_Cities),
  print_temp(structured, ConvertedList),
  {Max, Min} = find_max_and_min(ConvertedList),
  print_max_and_min(Max,Min).

convert_list_to_c([{Name, {f, F}} | Rest]) ->
  Converted_City = {Name, {c, (F - 32) * 5 / 9}},
  [Converted_City | convert_list_to_c(Rest)];

convert_list_to_c([Head | Rest]) ->
  [Head | convert_list_to_c(Rest)];

convert_list_to_c([]) ->
  [].
convert_to_c({Name, {f, F}}) ->
  {Name, {c, (F - 32) * 5 / 9}};
convert_to_c({Name, {c, Temp}}) ->
  {Name, {c, Temp}}.

convert_list_to_c_with_fun(List) ->
  NewList = lists:map(fun convert_to_c/1, List),
  lists:sort(fun({Name1, {c, Temp1}}, {Name2,{c, Temp2}}) -> Temp1 < Temp2 end, NewList ).



print_temp(structured, [{Name, {c, Temp}} | Rest]) ->
  io:format("~-15w ~w c~n", [Name, Temp]),
  print_temp(structured, Rest);

print_temp(structured, []) ->
  ok.

find_max_and_min([Head | Tail]) ->
  find_max_and_min(Tail, Head, Head).

find_max_and_min([{Name, {c, Temp}} | Rest],
    {Max_Name, {c, Max_Temp }},
    {Min_Name, {c, Min_Temp}}) ->
  if
    Temp > Max_Temp ->
      Max_City = {Name, {c, Temp}};

    true ->
      Max_City = {Max_Name, {c, Max_Temp}} % change
  end,
  if
    Temp < Min_Temp ->
      Min_City = {Name, {c, Temp }};
    true ->
      Min_City = {Min_Name, {c, Min_Temp}}
  end,
  find_max_and_min(Rest, Max_City, Min_City);

find_max_and_min([], Max_City, Min_City) ->
  {Max_City, Min_City}.


print_max_and_min({Max_Name ,{c, Max_Temp}}, {Min_Name, {c,  Min_Temp}}) ->
  io:format("Max Temperature was ~w celcius in ~w~n", [Max_Temp, Max_Name]),
  io:format("The Minimum Temperature was ~w cecius in ~w~n", [Min_Temp, Min_Name]).

test_if(A,B) ->
  if
    A == 5 ->
      io:format("A == 5~n", []),
      a_is_equal_to_five;
    B == 6 ->
      io:format("B == 6~n", []),
      b_is_equal_to_6;
    A == 7, B == 8 ->
      io:format("A == 7 AND B == 8 ~n",[]),
      a_is_equal_to_7_and_b_is_equal_to_8;

    A == 9; B == 10 ->
      io:format("A == 1 OR B == 7 ~n",[]) ,
      a_is_equal_to_9_or_b_is_equal_to_10;
    true ->
      io:format("annon ~n", []),
      annon_val

  end.

month_length(Year, Month) ->
  Leap = if
           trunc(Year / 400) * 400 == Year ->
             leap;
           trunc(Year / 100) * 100 == Year ->
             not_leap;
           trunc(Year / 4) * 4 == Year ->
             leap;
           true ->
             not_leap
         end,
  case Month of
    sep -> 30;
    apr -> 30;
    jun -> 30;
    nov -> 30;
    feb when Leap == leap -> 29;
    feb -> 28;
    jan -> 31;
    mar -> 31;
    may -> 31;
    jul -> 31;
    aug -> 31;
    oct -> 31;
    dec -> 31
  end.

%% BIFs: https://www.erlang.org/doc/man/erlang.html

%% HOFs


