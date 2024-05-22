%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. May 2024 11:12
%%%-------------------------------------------------------------------
-module(udp_sockets).
-author("phiri").

%% API
-export([server_udp/1, client_udp/2]).

%% udp

server_udp(Port) ->
  {ok, Socket} = gen_udp:open(Port, [binary]),
  io:format("server udp opened socket: ~p~n",[Socket]),
  loop_udp(Socket).


loop_udp(Socket) ->
  receive
    {udp, Socket, Host, Port, BinData} ->
      io:format("udp server received binary data: ~p~n",[BinData]),
      BinReply = term_to_binary({ok, 123}),
      gen_udp:send(Socket, Host, Port, BinReply),
      loop_udp(Socket) ;
    {Other} -> 
      io:format("received other messages: ~p~n",[Other])
  end.


client_udp(Port, Request) -> 
  {ok, Socket} = gen_udp:open(0, [binary]),
  ok = gen_udp:send(Socket, "localhost", Port, Request),
  Value = receive  
            {udp,Socket,Host,Port,Bin} -> 
              io:format("received data on host=~p, port=~p~n",[Host,Port]),
              io:format("Data received=~p~n",[binary_to_term(Bin)]),
              {ok, Bin}
            after 2000 ->
              error
          end,
  gen_udp:close(Socket),
  Value.