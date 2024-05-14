%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2024 11:20
%%%-------------------------------------------------------------------
-module(for_real_numbers).
-author("phiri").

%% API
-export([]).
%%% reserved atoms: after andalso band begin bnot bor bsl bsr bxor case catch cond div end fun if let not of or orelse query receive rem try when xor
%%%% to short circuit use andalso, orelse, do not use and , or
%%% use brackets in shell (not true).


%%% Test for equality
%%% (5 =:= 5).
%%% 5 == 5.0 uses exact equality , 5 /= 5.0

%%%% The correct ordering of each element: number < atom < reference < fun < port < pid < tuple < list < bitstring

%%%% List comprehensions: {2n : n in L} can be create as [2*N || N <- [1,2,3,4]]
%%% with filters: [X || X <- [1,2,3,4,5,6], X rem 2 =:= 0].

list_comprehension() ->
  List_One = [X || X <- [1,2,3,4,5,6,7,8,9,10], X rem 2 =:= 0 and X > 2  ],
  io:format("List one: ~n~p~n", [List_One]).

list_comprehension_multi_var() ->
  Weather = [{torronto, rain}, {montreal, storms}, {london, fog}, {paris, sun}, {boston, fog}
    , {vancouver, snow}] ,
  Foggy_Places = [X || {X, fog} <- Weather, {X, sun} <- Weather],
  io:format("foggy and sunny cities in canada: ~p~n", [Foggy_Places]).


%%% (gollum@127.0.0.1)25> Weather = [{toronto, rain}, {montreal, storms}, {london, fog}, {paris, sun},
%%% {boston, fog}, {vancouver, snow}].
%%% (gollum@127.0.0.1)26> FoggyAndSunnyPlaces = [X, {X, fog} <- Weather, {X, sun} <- Weather].

%%% 4> Pixels = <<1,2,3,4,5,6,7,8,9,10,11,12>>.

% BIT SYNTAX:
bit_syntax_one() ->
  Pixels = <<1,2,3,4,5,6,7,8,9,10,11,12>>,
  <<R:8, Tails/binary>> = Pixels, %%% <<R:12, Tail/binary>> wont work, 12 is not a multiple of 8
  io:write("R: ~p~n, Tails: ~p~n", [R, Tails]). %%% R = 1
%%%% 11> <<R:8, Tail/binary>> = Pixels.
%%% Value/TypeSpecifierList   Value:Size/TypeSpecifierList
%%% Possible types:     Possible values: integer | float | binary | bytes | bitstring | bits | utf8 | utf16 | utf32

%%% Signedness:     Possible values: signed | unsigned
%%% Endianness:      Possible values: big | little | native
%%% Endianness only matters when the Type is either integer, utf16, utf32, or float.

%% HOW TO SPECIFY multple types: <<X2/integer-signed-little-unit:8>> = <<72,0,0,0>>
bit_syntax_multiple_types() ->
  <<X/integer-signed-little-unit:8>> = <<72,0,0,0>>,
  io:write("signed multiple types: ~p~n", [X]).
%%% <<SourcePort:16, DestinationPort:16,
%%  AckNumber:32,
%%  DataOffset:4, _Reserved:4, Flags:8, WindowSize:16,
%%  CheckSum: 16, UrgentPointer:16,
%%  Payload/binary>> = SomeBinary.


%% BInary operations:
%%% The standard binary operations (shifting bits to left and right, binary 'and', 'or', 'xor', or 'not') also exist in Erlang.
%%% Just use the functions bsl (Bit Shift Left), bsr (Bit Shift Right), band, bor, bxor, and bnot.

% BinaryComprehension:
%%% 19> BinaryComprehension = [ X ||   <<X>> <= <<1,2,3,4,5,6>>, X rem 2 == 0].
%%% Pixels = <<1,2,3,4,5,6,7,8,9,10,11,12>>.
%%% 21> RGBComprehension = [ {R, G, B} ||<<R:8,G:8,B:8>> <= Pixels ].
binary_comprehension() ->
  Binary_Comprehension = [X || <<X>> <= <<1,2,3,4,5,6>>, X rem 2 == 0],
  io:format("Binary Comprehension: ~p~n", [Binary_Comprehension]).

binary_comprehension_two() ->
  Pixels = <<213,45,132,64,76,32,76,0,0,234,32,15>>,
  RGB = [ {R,G,B} || <<R:8,G:8,B:8>> <= Pixels ],
  io:format("Binary Comprehension Efficient: ~p~n", [RGB]).

