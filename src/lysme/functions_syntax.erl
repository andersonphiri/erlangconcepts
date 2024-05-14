%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Mar 2024 00:38
%%%-------------------------------------------------------------------
-module(functions_syntax).
-author("phiri").

%% API
-export([]).
-export_type([my_key_value/2]).
%%% with muliple guards
is_aged(X)  when X > 5, X =< 120 -> %% comma , means andalso
  true;
is_aged(X) when X == 30; X == 34 -> %%% ; semi-colon will mean orelse
  false.

if_else(X) ->
  if
    X =:= 2 ->  even;
    true -> false
  end.


string_concatenating() ->
  "Hello " "Naam" " is" " anderson".

- type my_camera() :: {'cam', reference(), port()}.
- type my_proc() :: {'proc', pid()}.
- type my_money(Dollars, Cents) :: {dollars, Dollars, cents , Cents}.
- type port_pid_union() :: port() | pid().
- type my_key_value(Key, Value) :: {key, Key, value, Value}. %%% -export_type([my_key_value/2]).
- opaque my_opaque_key_value(Key, Value) :: {key, Key, value, Value}. %%% -export_type([my_key_value/2]).

%%%% defining types using records
%%% the format is:
- record(my_record, {camera::my_camera(), cost::my_money() }).

%%%%% record keys with default values
- record(camera_dimensions, {length = 0 :: number(), width = 0 :: number(), height = 0:: number()}).

%%%% defining types and remove dialyzer errors

- type my_height() :: pos_integer().
- record(person, {name:: string(), height :: my_height() | _ }). %%% then you can filter #person{name=Name, _}
- type person() :: #person{height :: my_height()}.

%%%% Spec, type specifications
%%% - spec Function(ArgType1,ArgType2,..., ArgTypeN) -> ReturnType.
- spec foo(T1 ::string(), T2 :: string()) -> string().
- spec bar(X :: number(), Y:: number()) -> number();
    (X :: string(), Y:: float()) -> string(). %%% overloaded

%%% spec with guards
- spec foo_bar(X) -> X when X :: tuple(). %%% means when X is a subtype tuple()

%%%% void functions
- spec my_error(term()) -> no_return().

%%%% patterns
f_string_prefix_easy("string preffix" ++ Str) ->
  {ok, pattern_match_for_string_prefix}.

f_string_prefix_hard([$s,$t, $r,$i,$n,$g,$ , $p, $r,$e,$f,$f, $i,$x |Str]) ->
  {ok, pattern_match_for_string_prefix}.

