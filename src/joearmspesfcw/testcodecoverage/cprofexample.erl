%%%=============================================================================
%%% @doc cprofexample
%%% @end
%%%=============================================================================

%%% @author anderson phoro <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 03 Jun 2024 by anderson phiri <andersonp@generictechnologie.com>
-module(cprofexample).


-define(NYI(X), (begin 
        io:format("**** NYI ~p ~p ~p~n", [?MODULE, ?LINE, X]),
        exit(nyi)
    )).
steps_to_profile(Func) -> 
    cprof:start(),
    %% shoutcast:run() 
    Func(),
    cprof:pause(),
    cprof:analyse(),
    cprof:stop().

test_code_coverage(ModuleName, Func, Args) when is_list(Args) ->
    cover:start(),
    cover:compile(ModuleName),
    apply(ModuleName, Func, Args), %% let the code run for a while to collect metrics
    cover:analyse(ModuleName). %% the file shows number of times a code line is being executed. the lines showing 0 might mena that we need to create test cases to execute them


%%% checking cross refrencing 
%%% rm *.beam && erlc +debug_info *.erl && erl 
%% xref:d('.')


dump_to_a_file(File, Term) ->
    Out = filename:join(File, ".tmp"),
    io:format("*** dumping to ~s~n",[Out]),
    {ok, S} = file:open(Out, [write]),
    io:format(S, "~p.~n",[Term]),
    file:close(S).


%%% using error logger : erl -config elog5.config


%%% opening the debugger
%% im().
%% ii(name_if_module).


