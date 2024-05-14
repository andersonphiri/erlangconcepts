%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2024 14:40
%%%-------------------------------------------------------------------
-module(afile_client).
-author("phiri").

%% API
-export([ls/1, get_file/2]).


%%% client commands
ls(Server) ->
  Server ! {self(), list_dir} ,
  receive
    {Server, List_Of_Files} ->
      List_Of_Files
  end.

get_file(Server, File) ->
  Server ! {self(), {get_file, File}} ,
  receive
    {Server, Content} ->
      Content
  end.