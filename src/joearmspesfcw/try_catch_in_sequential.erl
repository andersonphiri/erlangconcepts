%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2024 16:34
%%%-------------------------------------------------------------------
-module(try_catch_in_sequential).
-author("phiri").

%% API
-export([demo/0, demo_with_catch/0, validate/1]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};

generate_exception(5) -> error(a).

catcher(N) ->
  try generate_exception(N) of
      Val  -> {N, normal, Val}
  catch
    throw: X  -> {N, caught, thrown, X};
    exit: X -> {N, caught, exited, X} ;
    error: X -> {N, caught, error, X, stack_trace, stack_tr}
    %% catch all errors
    %% _:_ -> {catchall}
  end.

demo() ->
  [catcher(I) || I <- [1,2,3,4,5]].

demo_with_catch() ->
  [{I, (catch generate_exception(I))}  || I <- [1,2,3,4,5]].


validate(L) -> validate_user_input(L).
validate_user_input(L) when is_list(L) ->
  {ok, 10 };
validate_user_input(L) -> error({parameter_is_not_list, L}).


%% contd pp96
