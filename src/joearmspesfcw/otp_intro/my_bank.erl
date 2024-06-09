%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%% introduces gen_server
%%% @end
%%% Created : 09. Jun 2024 1:07 AM
%%%-------------------------------------------------------------------
-module(my_bank).
-behavior(gen_server).

-author("chikuse2").

%% API
-export([start/0, stop/0,new_account/1, deposit/2, withdraw/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
%% -define(SERVER, 'bank@127.0.0.1').
-define(SERVER, ?MODULE).

init([]) -> {ok, ets:new(?MODULE,[])}.

start() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [],[]).
stop() -> gen_server:call(?MODULE, stop).

new_account(Who) -> gen_server:call(?MODULE, {new, Who}).
deposit(Who, Amount) -> gen_server:call(?MODULE, {add, Who, Amount}).
withdraw(Who,Amount) -> gen_server:call(?MODULE, {remove, Who, Amount}).




%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%% {stop, Reason, State}
%% @end %%--------------------------------------------------------------------
handle_call({new, Who}, _From, State) ->
  Reply = case ets:lookup(State,Who) of
            [] -> ets:insert(State,{Who,0}),
              {welcome, Who};
            [_] -> {Who, you_are_already_a_customer}
          end,
  {reply, Reply, State};

handle_call({add, Who, X}, _From, State) ->
  Reply = case ets:lookup(State,Who) of
            [] -> not_a_customer;
            [{Who, Balance}] ->
              NewBalance = Balance + X,
              ets:insert(State,{Who, NewBalance}),
              {thanks, Who, your_balance_is, NewBalance}
          end ,
  {reply, Reply, State};

handle_call({remove, Who, Amount}, _From, State) ->
  Reply = case ets:lookup(State,Who) of
            [] -> not_a_customer;
            [{Who,Balance}] when Amount =< Balance ->
              NewBalance = Balance - Amount,
              ets:insert(State,{Who, NewBalance}),
              {thanks, Who, your_balance_is, NewBalance};
            [{Who, Balance}] ->
              {sorry, Who, insufficient_balance, Balance,in_the_bank}
          end  ,
  {reply, Reply, State};

handle_call(stop,_From, State) ->
  {stop, normal,stopped, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%% {stop, Reason, State}
%% @end %%--------------------------------------------------------------------
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info,State) -> {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the <mod>gen_server</mod> terminates %% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason,_State) -> ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end %%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%% pp 381