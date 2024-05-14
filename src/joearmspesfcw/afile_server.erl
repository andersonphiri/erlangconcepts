%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2024 14:03
%%%-------------------------------------------------------------------
-module(afile_server).
-author("phiri").

%% API
-export([start/1, loop/1]).

start(Dir) ->
  spawn(afile_server, loop, [Dir]).

loop(Dir) ->
  %% Wait for Command
  receive
    {Client, list_dir} ->
      Client ! {self(), file:list_dir(Dir)} ;
    {Client, {get_file, File}} ->
      Full = filename:join(Dir, File) ,
      Client ! {self(), file:read_file(Full)}
  end,
  loop(Dir).
