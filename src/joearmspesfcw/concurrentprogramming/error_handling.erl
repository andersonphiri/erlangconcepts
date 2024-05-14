%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. May 2024 15:39
%%%-------------------------------------------------------------------
-module(error_handling).
-author("phiri").

%% API
-export([on_exit/2, on_exit_test/1, start_all_die_together/1]).

%% file:///D:/Scala-2024/books/Erlang-Elixir/Designing%20for%20Scalability%20with%20ErlangOTP%20Implement%20Robust,%20Fault-Tolerant%20Systems%20(Francesco%20Cesarini,%20Steve%20Vinoski)%20(Z-Library).pdf


%% pp 202

on_exit(Pid,Fun) ->
  spawn(fun() ->
           Ref = monitor(process,Pid),
          receive
            {'DOWN', Ref, process, Pid, Why} -> Fun(Why)
          end
        end).
%% To run, define a func
%% Func = fun() ->
%%1>     receive
%%1>        X ->  list_to_atom(X)
%%1>      end
%%1>    end.
%% newt spawn this func to get Pid
%% Pid = spawn(Func).
%% Then monitor this pid: error_handling:on_exit_test(Pid). %% note: on_exit_test will create a callback and then call monitoring func on_exit
%% the send a bad arg to Pid: Pid ! hello.


%% typicall output:
%% 9> Pid2 ! holla.
%% <0.96.0> being monitored has died. died because of: {badarg,
%%                                                      [{erlang,list_to_atom,
%%                                                        [holla],
%%                                                        [{error_info,
%%                                                          #{module =>
%%                                                             erl_erts_errors}}]}]}
%%holla
%%=ERROR REPORT==== 14-May-2024::12:25:25.344013 ===
%%Error in process <0.96.0> with exit value:
%%{badarg,[{erlang,list_to_atom,
%%                 [holla],
%%                 [{error_info,#{module => erl_erts_errors}}]}]}

on_exit_test(Pid) ->
  Fun = fun(Why) ->
            io:format(" ~p being monitored has died. died because of: ~p~n",[Pid,Why])
        end,
  on_exit(Pid, Fun).

%% observer:start() will start observer window
%% Processes that die altogether
start_all_die_together(Functions) ->
  Pid = spawn(fun() ->
    [spawn_link(F) || F <- Functions] ,
    receive
      after infinity -> true
    end
  end),
  Fun = fun(Why) ->
    io:format(" ~p being monitored has died. died because of: ~p~n",[Pid,Why])
        end,
  on_exit(Pid, Fun), %% Pid will exit
  Pid. %% return pid to user for testing

%% A process that never dies
keep_alive(Name, Fun) ->
  register(Name, Pid = spawn(Fun)),
  on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).

