%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(prime_server).

-behaviour(gen_server).

-export([start_link/0, new_prime/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(prime_server_state, {prime_number = 0 :: number() }).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p starting ~n", [?MODULE]),
  {ok, #prime_server_state{  }}.

handle_call({prime, K}, _From, State = #prime_server_state{}) -> 
  NextNumber = State#prime_server_state.prime_number + 1,
  NextState = State#prime_server_state{prime_number = NextNumber + 1 },
  {reply, make_new_prime(K), NextState}.

handle_cast(_Request, State = #prime_server_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #prime_server_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #prime_server_state{}) ->
  io:format("~p stopping ~n",[?MODULE]),
  ok.

code_change(_OldVsn, State = #prime_server_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%% pp394 


new_prime(N) ->
  gen_server:call(?MODULE, {prime, N}, 2000).

make_new_prime(K) -> 
  if
    K > 100 ->
      alarm_handler:set_alarm(tooHot),
      N = lib_primes:make_prime(K),
      alarm_handler:clear_alarm(tooHot),
      N;
    true ->
      lib_primes:make_prime(K)
      
  end.



