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
-include_lib("kernel/include/file.hrl").

%% API
-export([read_config_files/0, read_config_file_term_by_term/2, read_file_line_by_line/2,
  unconsult/2, formating_styles/0, ls/1, files/3, files/5]).


read_config_files() ->
  case file:consult("./config.dat") of %% will read all terms in a file separated by a .
    {ok, Terms}  -> Terms;
    Any -> Any
  end.

read_config_file_term_by_term(FilePath, TermHandlerFunc) ->
  case file:open(FilePath, read) of
    {ok, Stream} ->
      read_config_file_term_by_term_util(Stream, TermHandlerFunc),
      io:format("closing file.~n"),
      file:close(Stream);

    Any -> Any
  end.


read_file_line_by_line(FilePath, TermHandlerFunc) ->
  case file:open(FilePath, read) of
    {ok, Stream} ->
      read_config_file_line_by_line_util(Stream, TermHandlerFunc),
      io:format("closing file.~n"),
      file:close(Stream);

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

read_config_file_line_by_line_util(FileStream, LineHandlerFunc) ->
  NextLine = io:get_line(FileStream,''),
  case NextLine of
    {ok, Data} ->
      LineHandlerFunc(Data)  ,
      read_config_file_term_by_term_util(FileStream, LineHandlerFunc);
    Eof = eof -> Eof
  end.
%% CMD + Shift + G to show hidden files like /asdf/.something/then/something

unconsult(ListOfTerms, FileName) ->
  {ok, Stream} = file:open(FileName, write),
  ItemHandlerFunc = fun(Term) -> io:format(Stream, "~p.~n",[Term]) end ,
  lists:foreach(ItemHandlerFunc, ListOfTerms),
  file:close(Stream),
  ok.

formating_styles() ->
  io:format("|~10s|~n",["abc"]),
  io:format("|~-10s|~n",["abc"]),
  io:format("|~10.3.+s|~n",["abc"]),
  io:format("|~-10.10.+s|~n",["abc"]),
  io:format("|~10.7.+s|~n",["abc"]).


file_size_and_type(File) ->
  case file:read_file_info(File) of
    {ok, Facts} ->
      {Facts#file_info.type, Facts#file_info.size};
    _ -> error
  end.

ls(Dir) ->
  {ok, L} = file:list_dir(Dir),
  lists:map(fun(I) -> {I, file_size_and_type(I)} end, lists:sort(L)).




%%% file finder project


file_type(File) ->
  case file:read_file_info(File) of
    {ok, Facts} ->
      case Facts#file_info.type of
        regular -> regular;
        directory -> directory;
        _ -> error
      end ;
    _ -> error
  end.

files(Dir,Reg,Flag) ->
  Re1 = xmerl_regexp:sh_to_awk(Reg),
  lists:reverse(files(Dir,Re1,Flag, fun(File,Acc) -> [File | Acc] end, [])).

files(Dir,Reg,Recursive,Fun,Acc) ->
  case file:list_dir(Dir) of
    {ok, Files} -> find_files(Files, Dir,Reg, Recursive,Fun, Acc);
    {error, _} -> Acc
  end .

find_files([File | T], Dir, Reg, Recursive, Fun, Accumulator) ->
  FullName = filename:join([Dir, File]),
  case file_type(FullName) of
    regular ->
      case re:run(FullName,Reg, [{capture, none}]) of
        match ->
          AccumulatorNext = Fun(FullName, Accumulator),
          find_files(T,Dir,Reg,Recursive, Fun, AccumulatorNext);
        nomatch -> find_files(T, Dir, Reg, Recursive, Fun, Accumulator)

      end ;
    directory ->
      case Recursive of
        true ->
          Accumu1 = files(FullName, Reg, Recursive, Fun, Accumulator),
          find_files(T, Dir, Reg, Recursive,Fun, Accumu1);
        false ->
          find_files(T, Dir, Reg, Recursive, Fun, Accumulator)

      end;
    error ->
      find_files(T, Dir, Reg, Recursive, Fun, Accumulator)
  end ;
find_files([], _,_,_,_, A) -> A .




























