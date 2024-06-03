%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 03 Jun 2024 by anderson phiri <andersonp@generictechnologie.com>
-module(tracer_test).
-compile([export_all]).
trace_module(Mod, StartFunc) -> 
    spawn(fun() -> trace_module_util(Mod, StartFunc) end).

trace_module_util(Mod, StartFunc) -> 
    erlang:trace_pattern({Mod, '_','_'}, 
        [{'_',[], [{return_trace}]}],
        [local]),
    Self = self(),
    Pid = spawn(fun() -> do_trace(Self, StartFunc) end),
    erlang:trace(Pid, true, [call, procs]),
    Pid ! {self(), start} ,
    trace_loop().


%%------------------------------------------------------------------------------
%% @doc trace_loop
%% wait for traces in the receive block
%% @end
%%------------------------------------------------------------------------------
trace_loop() -> 
    receive
      {trace, _, call, X} ->
        io:format("Call: ~p~n", [X]),
        trace_loop();

      {trace,_,  return_from, Call,Ret} ->
        io:format("Return From: ~p => ~p~n",[Call,Ret]),
        trace_loop();
      
      Other -> 
        io:format("Other = ~p~n", [Other]),
        trace_loop()   
    end.


%%------------------------------------------------------------------------------
%% @doc do_trace
%% evaluates StartFunc when it is told to do so by Parent
%% @end
%%------------------------------------------------------------------------------
do_trace(Parent, StartFunc) ->
    receive
        {Parent, start} -> 
            StartFunc()
    end.

fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

run_trace_tests() -> 
    trace_module(tracer_test, fun() -> tracer_test:fib(20) end).

run_trace_tests2() -> 
    dbg:tracer(),
    dbg:tpl(tracer_test, fib, '_', dbg:fun2ms(fun(_) -> return_trace() end)),
    dbg:p(all, [c]),
    tracer_test:fib(6).
