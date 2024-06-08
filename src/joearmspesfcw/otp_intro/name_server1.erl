%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 04 Jun 2024 by anderson phiri <andersonp@generictechnologie.com>
-module(name_server1).
-import(server3, [rpc/2]).
-export([init/0, add/2, find/1, handle/2]).
init() -> dict:new().

add(Name, Place) -> rpc(name_server,{add, Name,Place}).
find(Name) -> rpc(name_server,{find, Name}).

handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict}.
    




