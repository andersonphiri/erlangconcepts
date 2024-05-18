%%%-------------------------------------------------------------------
%%% @author chikuse2
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. May 2024 9:35 PM
%%%-------------------------------------------------------------------
-module(sockets_example).
-author("chikuse2").

%% API
-export([nano_get_url/0, nano_get_url/1]).

nano_get_url() -> nano_get_url("google.com").
nano_get_url(Host) ->
  {ok, Socket} = gen_tcp:connect(Host, 80,[binary, {packet, 0}]) ,
  ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
  receive_data(Socket,[]).
  %% pP 268

receive_data(Socket, SoFar) ->
  receive
    {tcp, Socket, Bin} ->
      receive_data(Socket, [Bin | SoFar]);
    {tcp_closed, Socket} ->
      list_to_binary(lists:reverse(SoFar))
  end.


%% convert binarydata to lines of strings
%% string:tokens(binary_to_list(Data), "\r\n").

%% start_nano_server() pp 272


