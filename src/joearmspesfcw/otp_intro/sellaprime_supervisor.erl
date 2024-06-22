-module(sellaprime_supervisor).
-behaviour(supervisor).

%% API
-export([start/0, start_in_shell_for_testing/0, start_link/1]).
-export([init/1]).

start() ->
    spawn(fun() -> 
        supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
            end).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid). 

start_link(Args) ->
    supervisor:start_link({local,?MODULE}, ?MODULE, Args).

init(_Args) ->

    gen_event:swap_handler(alarm_handler, {alarm_handler, swap}, {my_alarm_handler, xyz}),


    SupervisorSpecification = #{
        strategy => one_for_one, % one_for_one | one_for_all | rest_for_one | simple_one_for_one
        intensity => 10,
        period => 60},

    ChildSpecifications = [
        #{
            id => tag1,
            start => {area_server, start_link, []},
            restart => permanent, % permanent | transient | temporary
            shutdown => 10000, % use 'infinity' for supervisor child
            type => worker, % worker | supervisor
            modules => [area_server]
        } , #{
            id => tag2,
            start => {prime_server, start_link, []},
            restart => permanent ,
            shutdown => 10000, 
            type => worker,
            modules => [prime_server]
        }
    ],

    {ok, {SupervisorSpecification, ChildSpecifications}}.
