%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 4月 2024 11:29
%%%-------------------------------------------------------------------
-module(lib_misc).
-author("phiri").

%% API
-export([forloop/3, for/4, for_inc/4,for_dec/4, pythagorean_triples/1, quick_sort/1, permute/1, odds_evens/1,
  count_chars/1
  ]).

forloop(To,To, Func) -> [Func(To)];
forloop(From,To,  _) when From > To -> [];
forloop(From, To, Func) -> [Func(From) | forloop(From + 1, To, Func)].

for(To,To,_,_) -> [To];
for(From,To, IncFunc, Func) when From =< To -> for_inc(From,To, IncFunc, Func);
for(From,To, IncFunc, Func) when From > To -> for_dec(From,To, IncFunc,Func).

for_inc(To,To,_,Func) -> [Func(To)];
for_inc(From,To, _, _) when From > To   -> [];
for_inc(From,To, IncFunc, Func) when From < To -> [Func(From) | for_inc(IncFunc(From), To,IncFunc,Func)].

for_dec(To,To,_,_) -> [To];
for_dec(From,To, _, _) when From < To   -> [];
for_dec(From,To, IncFunc, Func) when From > To -> [ Func(From) | for_dec(IncFunc(From), To,IncFunc,Func)].

quick_sort([]) -> [];
quick_sort([Pivot | T]) ->
  quick_sort([X || X <- T, X , Pivot])
  ++ [Pivot] ++
  quick_sort([X || X <- T, X >= Pivot]). %% ++ is a infix and bad practise

pythagorean_triples(N) when N > 1 ->
  [
    {A,B,C} || A <- lists:seq(1,N) , B <- lists:seq(1,N), C <- lists:seq(1,N),
    A+B+C =< N ,
    A*A + B*B =:= C*C
  ];
pythagorean_triples(_)  -> [].

%%% anagrams / string perms
permute([]) -> [ [] ];
permute(L) ->
  [  [H|T]  || H <- L, T <- permute(L -- [H]) ].


odds_evens(L) when is_list(L) -> odds_evens_accum(L, [], []);
odds_evens(_) -> {[], []}.

odds_evens_accum([H | T], Odds, Evens) ->
  case (H rem 2) of
    0 -> odds_evens_accum(T,Odds, [H | Evens]);
    1 -> odds_evens_accum(T,[ H |Odds ], Evens)
  end;
odds_evens_accum([], Odds, Evens) -> {Odds, Evens}.

count_chars(Str) -> count_chars(Str, maps:new()).

count_chars([H | T],  X) ->
  Count = maps:get(H,X, 0),
  case Count of
    0 -> count_chars(T, X#{H => 1});
    _ -> count_chars(T, X#{H => Count + 1})
  end;
count_chars([], X) -> X.


%%% use pattern matching
%% count_chars_pm(Str) -> count_chars_pm(Str, maps:new()).

%%  count_chars_pm([H | T], #{H => Count } = X) ->
%%   count_chars_pm(T, X#{H := Count + 1});
%%  count_chars_pm([H| T], X) -> count_chars_pm(T, X#{H := 1});
%%  count_chars_pm([], X) -> X.


%% To empty all messages in the queue
%% without timeout clause, flush_buffer() hangs forever

flush_buffer() ->
  receive
    _Any ->
      flush_buffer()
  after 0 -> %% a timeout of zero causes the timeout to exit immediately, but before this happens the system tries to empty mailbox of the process
    true
  end.

%% Do not use this technique for large mailboxes, it is inefficient
priority_receive() ->
  receive
    {alarm, X} ->
      {alarm, X}
  after 0 ->
    receive
      Any ->
        Any
    end

  end.


string2value(Str) ->
  {ok, Tokens, _} = erl_scan:string(Str ++ "."),
  {ok, Exprs} = erl_parse:parse_exprs(Tokens),
  Bindings = erl_eval:new_bindings(),
  {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
  Value.
