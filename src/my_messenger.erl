%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Feb 2024 10:10
%%%-------------------------------------------------------------------
-module(my_messenger).
-author("phiri").
-export([start_server/0, server/0, server/1, logon/1, logoff/0, message/2, client/2, server_node/0]).


server_node() ->
  'kosken@127.0.0.1'.

server() ->
  process_flag(trap_exit, true),
  server([]).

server(User_List) ->
  receive
    {From, logon, Name} ->
      New_User_List = server_logon(From, Name, User_List),
      server(New_User_List);
    {'EXIT', From, _} ->
      New_User_List = server_logoff(From, User_List),
      server(New_User_List);
    {From, logoff} ->
      New_User_List = server_logoff(From, User_List),
      server(New_User_List);
    {From, message_to, To, Message} ->
      server_transfer(From, To, Message, User_List),
      io:format("list is now: ~p~n", [User_List]),
      server(User_List)
  end.



%%% Start the server
start_server() ->
  register(my_messenger, spawn(my_messenger, server, [[]])).

%%% Server adds a new user to the user list
server_logon(From, Name, User_List) ->
  %% check if logged on anywhere else
  case lists:keymember(Name,2,User_List) of
    true ->
      From ! { my_messenger, stop, user_exists_at_other_node } ,
      User_List;
    false ->
      From ! {my_messenger, logged_on} ,
  [{From, Name} | User_List]
  end.

%%% server deletes a user from the users list
server_logoff(From, User_List) ->
  lists:keydelete(From,1,User_List).

%%% server transfers a message between user
%%% Server transfers a message between user
server_transfer(From, To, Message, User_List) ->
%% check that the user is logged on and who he is
  case lists:keysearch(From, 1, User_List) of
    false ->
      From ! {my_messenger, stop, you_are_not_logged_on};
    {value, {From, Name}} ->
      server_transfer(From, Name, To, Message, User_List)
  end.
%%% If the user exists, send the message
server_transfer(From, Name, To, Message, User_List) ->
%% Find the receiver and send the message
  case lists:keysearch(To, 2, User_List) of
    false ->
      From ! {my_messenger, receiver_not_found};
    {value, {ToPid, To}} ->
      ToPid ! {message_from, Name, Message},
      From ! {my_messenger, sent}
  end.


%%% User commands
logon(Name) ->
  case whereis(mess_client) of % mess_client
    undefined ->
      register(mess_client,
        spawn(my_messenger, client, [server_node(), Name])),
      io:format("new user logged in: ~p~n", [Name]);
    _ -> already_logged_on
  end.

logoff() ->
  mess_client ! logoff.

message(ToName, Message) ->
  case whereis(mess_client) of % Test if the client is running
    undefined ->
      not_logged_on;
    _ -> mess_client ! {message_to, ToName, Message},
      ok
  end.


%%% The client process which runs on each server node
client(Server_Node, Name) ->
  {my_messenger, Server_Node} ! {self(), logon, Name},
  await_result(),
  client(Server_Node).

client(Server_Node) ->
  receive
    logoff ->
      {my_messenger, Server_Node} ! {self(), logoff},
      exit(normal);
    {message_to, ToName, Message} ->
      {my_messenger, Server_Node} ! {self(), message_to, ToName, Message},
      await_result();
    {message_from, FromName, Message} ->
      io:format("Message from ~p: ~p~n", [FromName, Message])
  end,
  client(Server_Node).
%%% wait for a response from the server
await_result() ->
  receive
    {my_messenger, stop, Why} -> % Stop the client
      io:format("~p~n", [Why]),
      exit(normal);
    {my_messenger, What} -> % Normal response
      io:format("~p~n", [What])
  end.


