%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Mar 2024 01:53
%%%-------------------------------------------------------------------
-module(type_conversions).
-author("phiri").

%% API
-export([]).

%%% atom_to_binary/2, atom_to_list/1, binary_to_atom/2, binary_to_existing_atom/2,
%%% binary_to_list/1, bitstring_to_list/1, binary_to_term/1, float_to_list/1,
%%% fun_to_list/1, integer_to_list/1, integer_to_list/2, iolist_to_binary/1,
%%% iolist_to_atom/1, list_to_atom/1, list_to_binary/1, list_to_bitstring/1,
%%% list_to_existing_atom/1, list_to_float/1, list_to_integer/2, list_to_pid/1,
%%% list_to_tuple/1, pid_to_list/1, port_to_list/1, ref_to_list/1, term_to_binary/1, term_to_binary/2 and tuple_to_list/1
type_conversions() ->
  ListToINteger = list_to_integer("55"),
  IntegerToList = integer_to_list(55),
  ListToBitString = list_to_bitstring("hello"), %%% <<"hello">>
  BitStringToString = bitstring_to_list(<<"hello">>).

%%% is_atom/1           is_binary/1
%%is_bitstring/1      is_boolean/1        is_builtin/3
%%is_float/1          is_function/1       is_function/2
%%is_integer/1        is_list/1           is_number/1
%%is_pid/1            is_port/1           is_record/2
%%is_record/3         is_reference/1      is_tuple/1
type_tests() ->
  {yes, yes}.

%%% abs(Number), bit_size(Bitstring), byte_size(Bitstring),
%%% element(N, Tuple), float(Term), hd(List),
%%% length(List), node(), node(Pid|Ref|Port), round(Number), self(),
%%% size(Tuple|Bitstring), tl(List), trunc(Number), tuple_size(Tuple)
some_important_bifs() ->
  {ofcourse, yes}.


