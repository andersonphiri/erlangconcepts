%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. May 2024 11:19
%%%-------------------------------------------------------------------
-module(compiling_code).
-author("phiri").

%% API
-export([]).

%% code:get_path(). to get a list all current load paths
%% code:add_patha(Dir) - to add to to the beginning og the code search paths
%% code:add_pathz(Dir) - to add to the end of the list of code search paths
%% code:all_loaded() - returns a list of modules
%% code:clash() - to investigate what went wrong

%% alternatively start erlang as: erl -pa Dir1 -pa Dir2 ... -pz DirK1 -pz DirK2

%% TO Execute escript:
%% erl -eval 'io:format("Memory: ~p~n", [erlang:memory(total)]).' -noshell -s init stop

%% hello.sh
%% #!/bin/sh
%% erl -noshell -pa /home/anderson/LearnErlang-2024/LearnErlang-2024/learnyousomeerlang/src/joearmspesfcw -s hello start -s init stop
