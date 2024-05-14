%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2024 13:03
%%%-------------------------------------------------------------------
-module(function_guards).
-author("phiri").

%% API
-export([]).
-record(my_tag, {name = "", size :: number()}).
%%% pp 64 contd

%%% guard expressions:
%%% comma separated means and : GuardExpr1,GuardExpr2,GuardExpr3,...,GuardExprN will be true if all expressions are true
%%% semi-colon separated means or: GuardExpr1;GuardExpr2;GuardExpr3;...;GuardExprN will be true if any of the expressions is true



my_func(X)  when is_atom(X);is_binary(X); is_float(X) ; is_list(X); not(false) ; is_record(X,my_tag); X =:= dog ; X =:= cat ->
  {ok, true}.

my_func_with_short_circuit_guards(X) when X > 0 andalso X > 8 orelse X rem 2 =:= 0 -> {keyi, true}.


if_expression(X) ->
  if
    is_list(X) -> ok;
    true -> not_ok
  end.








