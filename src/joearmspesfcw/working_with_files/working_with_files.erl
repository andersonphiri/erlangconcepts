%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. May 2024 10:17
%%%-------------------------------------------------------------------
-module(working_with_files).
-author("phiri").

%% API
-export([read_config_files/0, read_config_file_term_by_term/2]).


read_config_files() ->
  case file:consult("./config.dat") of %% will read all terms in a file separated by a .
    {ok, Terms}  -> Terms;
    Any -> Any
  end.

read_config_file_term_by_term(FilePath, TermHandlerFunc) ->
  case file:open(FilePath, read) of
    {ok, Stream} ->
      read_config_file_term_by_term_util(Stream, TermHandlerFunc);
    Any -> Any
  end.

%% TO run: define a func accepting Read term to process 
read_config_file_term_by_term_util(FileStream, TermHandlerFunc) ->
  NextTerm = io:read(FileStream,''),
  case NextTerm of
    {ok, Data} ->
      TermHandlerFunc(Data)  ,
      read_config_file_term_by_term_util(FileStream, TermHandlerFunc);
    Eof = eof -> Eof
  end.
