%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. May 2024 10:27
%%%-------------------------------------------------------------------
-module(distributed_ftp).
-author("phiri").

%% API
-export([copy_file_from_remote_to_local/3,read_file_to_shell/2]).


copy_file_from_remote_to_local(SourceRemoteNode,RemoteFilePath,LocalDestinationPath) ->
  try
    copy_file_from_remote_to_local_util(SourceRemoteNode,RemoteFilePath,LocalDestinationPath)
  catch
    error: X -> {'source: ', RemoteFilePath, 'destination: ', LocalDestinationPath, caught, error, X, stack_trace, stack_tr}
    %% catch all errors
    %%_: All -> {All}
  end.

copy_file_from_remote_to_local_util(SourceRemoteNode,RemoteFilePath,LocalDestinationPath) ->
  {ok, FileBinary} = rpc:call(SourceRemoteNode,file,read_file, [RemoteFilePath]),
  io:format("destination path: ~p~n",[LocalDestinationPath]),
  io:format("Remote source path: ~p~n",[RemoteFilePath]),
  file:write_file(LocalDestinationPath,FileBinary).

read_file_to_shell(SourceRemoteNode,RemoteFilePath) ->
  io:format("Remote source path: ~p~n",[RemoteFilePath]),
  rpc:call(SourceRemoteNode,file,read_file, [RemoteFilePath]).