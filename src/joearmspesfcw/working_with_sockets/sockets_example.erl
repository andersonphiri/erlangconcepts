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
-export([nano_get_url/0, nano_get_url/1, start_nano_server/0, nano_client_eval/1, start_parallel_server/0, start_hybrid_server/1, chown_socket/2, start_seq_server/0]).

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

start_nano_server() ->
  {ok, Listen} = gen_tcp:listen(2345,[binary, {packet, 4},
    {reuseaddr, true}, {active, true}]),
  {ok, Socket} = gen_tcp:accept(Listen),
  loop(Socket).

%% start sequential server

start_seq_server() ->
  {ok, Listen} = gen_tcp:listen(2345,[binary, {packet, 4},
    {reuseaddr, true}, {active, true}]),
  seq_loop(Listen).

start_parallel_server() ->
  {ok, Listen} = gen_tcp:listen(2345,[binary, {packet, 4},
    {reuseaddr, true}, {active, true}]),
  spawn(fun() -> parallel_connect(Listen) end ).

parallel_connect(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  inet:setopts(Socket,[{packet, 4}, binary, {nodelay, true}, {active, true}]),
  spawn(fun() -> parallel_connect(Listen) end),
  loop(Socket).

seq_loop(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  inet:setopts(Socket,[{packet, 4}, binary, {nodelay, true}, {active, true}]),
  loop(Socket),
  seq_loop(Listen).


%% once off client
nano_client_eval(Str) ->
  {ok, Socket} = gen_tcp:connect("localhost", 2345,[binary, {packet, 4}]),
  ok = gen_tcp:send(Socket, term_to_binary(Str)),
  receive
    {tcp,Socket, Bin}  ->
      io:format("Client received binary = ~p~n",[Bin]),
      Val = binary_to_term(Bin),
      io:format("Client result = ~p~n", [Val]),
      gen_tcp:close(Socket)
  end.

string2value(Str) ->
  {ok, Tokens, _} = erl_scan:string(Str ++ "."),
  {ok, Exprs} = erl_parse:parse_exprs(Tokens),
  Bindings = erl_eval:new_bindings(),
  {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
  Value.


loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      log_client_ip(Socket),
      io:format("Server received binary  = ~p~n",[Bin]),
      Str = binary_to_term(Bin),
      io:format("Server unpacked: ~p~n",[Str]),
      Reply = string2value(Str),
      io:format("Server replying = ~p~n", [Reply]),
      gen_tcp:send(Socket, term_to_binary(Reply)),
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.


%% change process which owns a socket
chown_socket(Socket, NewOwnerPid) -> gen_tcp:controlling_process(Socket, NewOwnerPid).

%% hybrid approach

start_hybrid_server(PreferredPort) ->
  {ok, Listen} = gen_tcp:listen(PreferredPort, [binary, {packet, 4},
    {reuseaddr, true}, {active, once}]),
  {ok, Socket} = gen_tcp:accept(Listen),
  loop_hybrid(Socket).

loop_hybrid(Socket) ->
  receive
    {tcp, Socket, Data} ->
      %% Handle data here and set active again for next loop
      io:format("i have handleld data from socket~p~n",[Data]),
      inet:setopts(Socket, [{active, once}]),
      loop_hybrid(Socket);
    {tcp_closed, Socket} ->
      io:format("loop hybrid socket closed.~n")

  end.


log_client_ip(Socket) ->
  case inet:peername(Socket) of
    {ok, ClientInfo} -> io:format("received connection from ~p~n", [ClientInfo]);
    {error,Why} -> io:format("failed to capture connecting client info: ~p~n",[Why])
  end .

%% udp

server_udp(Port) ->
  {ok, Socket} = gen_udp:open(Port, [binary]),
  loop_udp(Socket).


loop_udp(Socket) ->
  receive
    {udp, Socket, Host, Port, BinData} ->
      BinReply = term_to_binary({ok, 123}),
      gen_udp:send(Socket, Host, Port, BinReply),
      loop_udp(Socket)
  end.