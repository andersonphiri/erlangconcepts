%%%--------- FILE mess_client.erl ----------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2024 22:02
%%%-------------------------------------------------------------------

%%% Client process which runs on user node

-module(mess_client).
-author("phiri").

%% API
-export([client/2]).

-include("mess_interface.hrl").

client(Server_Node, Name) ->
  {messenger, server_node} ! #logon{client_pid = self(), username = Name},
  await_result(),
  client(Server_Node).

client(Server_Node) ->
  receive
    logoff ->
      exit(normal);
    #message_to{message = Message, to_name = ToName } ->
      {messenger, Server_Node } ! #message{client_pid = self(), message = Message, to_name = ToName},
      await_result();
    {message_from, FromName, Message} ->
      io:format("Message from ~p: ~p~n", [FromName,Message])
  end,
  client(Server_Node).


%%% Wait for response from server
await_result() ->
  receive
    #abort_client{message = Why} ->
      io:format("~p~n",[Why]),
      exit(normal);
    #server_reply{message = What } ->
      io:format("~p~n", [What])
  after 5000 ->
    io:format("no response from server after timeout"),
    exit(timeout)
  end.

%%%--------- END OF FILE mess_client.erl -----------------------