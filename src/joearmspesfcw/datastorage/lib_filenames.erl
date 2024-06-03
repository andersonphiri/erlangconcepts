%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 30 May 2024 by anderson phiri <andersonp@generictechnologie.com>
-module(lib_filenames).

%% pp316 

%%------------------------------------------------------------------------------
%% @doc open
%% creates a dets with module name as identifier
%% @end
%%------------------------------------------------------------------------------ 

open(File) -> 
    io:format("dets opened:~p~n",[File]),
    Bool = filelib:is_file(File),
    case dets:open_file(?MODULE, [{file, File}]) of 
        {ok, ?MODULE} -> 
            case Bool of
                true -> void;
                false -> ok = dets:insert(?MODULE, {free, 1})
            end,
            true;
        {error, Reason} -> 
            io:format("cannot open dets table with name: ~p~n",[?MODULE]),
            exit({eDetsOpen, File, Reason})
    end.

%%------------------------------------------------------------------------------
%% @doc close
%% closes the dets doc file
%% @end
%%------------------------------------------------------------------------------
close() -> dets:close(?MODULE).

%%------------------------------------------------------------------------------
%% @doc filename2index
%% Write some docs
%% @end
%%------------------------------------------------------------------------------
filename2index(FileName) when is_binary(FileName) ->  %% Filename should be binary for efficienccy reasons
    case dets:lookup(?MODULE, FileName) of
        [] -> 
            [{_, Free}] = dets:lookup(?MODULE, free), %%% potentnial race conditions here
            ok = dets:insert(?MODULE, [{Free,FileName}, {FileName,Free}, {free, Free + 1}]), %% will upsert
            Free;
        [{_, N}] -> 
            N          
    end.


index2filename(Index) when is_integer(Index) -> 
    case dets:lookup(?MODULE, Index) of
        [] ->
            error;
        [{_ , Bin}] -> Bin
    end.



