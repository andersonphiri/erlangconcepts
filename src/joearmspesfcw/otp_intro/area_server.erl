-module(area_server).

-behaviour(gen_server).

%% API
-export([stop/1, start_link/1, area/1 , start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(area_server_state, {iteration = 0 :: number()}).

stop(Name) ->
    gen_server:call(Name, stop).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
    

start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

area(Thang) -> 
    gen_server:call(?MODULE,{area, Thang}).

init([]) ->
    process_flag(trap_exit, true),
    io:format("~p starting ~n",[?MODULE]),
    {ok, #area_server_state{ }}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

handle_call({area, Thang}, _From, State) ->
    Next = State#area_server_state.iteration + 1,
    {reply, compute_area(Thang), State#area_server_state{iteration = Next }}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("~p stopping ~n",[?MODULE]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


compute_area({square, X}) -> X * X;
compute_area({rectangly, X, Y}) -> X * Y.