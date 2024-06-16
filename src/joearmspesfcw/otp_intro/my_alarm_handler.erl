%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2024 5:30 PM
%%%-------------------------------------------------------------------
-module(my_alarm_handler).
-author("chikuse2").

-behaviour(gen_event).

%% API
-export([start_link/0, add_handler/0]).

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(my_alarm_handler_state, {count  = 0:: number() }).

%%%===================================================================
%%% gen_event callbacks
%%%===================================================================

%% @doc Creates an event manager
-spec(start_link() -> {ok, pid()} | {error, {already_started, pid()}}).
start_link() ->
  gen_event:start_link({local, ?SERVER}).

%% @doc Adds an event handler
-spec(add_handler() -> ok | {'EXIT', Reason :: term()} | term()).
add_handler() ->
  gen_event:add_handler(?SERVER, ?MODULE, []).

%%%===================================================================
%%% gen_event callbacks
%%%===================================================================

%% @private
%% @doc Whenever a new event handler is added to an event manager,
%% this function is called to initialize the event handler.
-spec(init(InitArgs :: term()) ->
  {ok, State :: #my_alarm_handler_state{}} |
  {ok, State :: #my_alarm_handler_state{}, hibernate} |
  {error, Reason :: term()}).
init(Args) ->
    io:format("**** my_alarm_handler init:~p~n", [Args]),
  {ok, #my_alarm_handler_state{ count = -1  }}.

%% @private
%% @doc Whenever an event manager receives an event sent using
%% gen_event:notify/2 or gen_event:sync_notify/2, this function is
%% called for each installed event handler to handle the event.
-spec(handle_event(Event :: term(), State :: #my_alarm_handler_state{}) ->
  {ok, NewState :: #my_alarm_handler_state{}} |
  {ok, NewState :: #my_alarm_handler_state{}, hibernate} |
  {swap_handler, Args1 :: term(), NewState :: #my_alarm_handler_state{},
    Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
  remove_handler).
handle_event({set_alarm, tooHot}, State = #my_alarm_handler_state{}) ->
  NextState = State#my_alarm_handler_state.count + 1,
  error_logger:error_msg("**** Tell the Engineer to turn ON the fan ****~n"),
  {ok, State#my_alarm_handler_state{count = NextState}};

handle_event({clear_alarm, tooHot}, State) ->
  error_logger:error_msg("**** Danger over. Turn off the fan ~n***"),
  {ok, State}.



%% @private
%% @doc Whenever an event manager receives a request sent using
%% gen_event:call/3,4, this function is called for the specified
%% event handler to handle the request.
-spec(handle_call(Request :: term(), State :: #my_alarm_handler_state{}) ->
  {ok, Reply :: term(), NewState :: #my_alarm_handler_state{}} |
  {ok, Reply :: term(), NewState :: #my_alarm_handler_state{}, hibernate} |
  {swap_handler, Reply :: term(), Args1 :: term(), NewState :: #my_alarm_handler_state{},
    Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
  {remove_handler, Reply :: term()}).
handle_call(Request, State = #my_alarm_handler_state{}) ->
  io:format("unmatched event: ~p~n",[Request]),
  Reply = ok,
  {ok, Reply, State}.

%% @private
%% @doc This function is called for each installed event handler when
%% an event manager receives any other message than an event or a
%% synchronous request (or a system message).
-spec(handle_info(Info :: term(), State :: #my_alarm_handler_state{}) ->
  {ok, NewState :: #my_alarm_handler_state{}} |
  {ok, NewState :: #my_alarm_handler_state{}, hibernate} |
  {swap_handler, Args1 :: term(), NewState :: #my_alarm_handler_state{},
    Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
  remove_handler).
handle_info(_Info, State = #my_alarm_handler_state{}) ->
  {ok, State}.

%% @private
%% @doc Whenever an event handler is deleted from an event manager, this
%% function is called. It should be the opposite of Module:init/1 and
%% do any necessary cleaning up.
-spec(terminate(Args :: (term() | {stop, Reason :: term()} | stop |
remove_handler | {error, {'EXIT', Reason :: term()}} |
{error, term()}), State :: term()) -> term()).
terminate(_Arg, _State = #my_alarm_handler_state{}) ->
  ok.

%% @private
%% @doc Convert process state when code is changed
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #my_alarm_handler_state{},
    Extra :: term()) ->
  {ok, NewState :: #my_alarm_handler_state{}}).
code_change(_OldVsn, State = #my_alarm_handler_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%% How to test: erl -boot start_sasl -config ./sasl_configs/elog2.config
%%% alarm_handler:set_alarm(tooHot).
%%% gen_event:swap_handler(alarm_handler,{alarm_handler, swap},{my_alarm_handler, xyz}).
%%% alarm_handler:set_alarm(tooHot)
