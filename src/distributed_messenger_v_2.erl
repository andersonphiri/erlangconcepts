%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Mar 2024 04:43
%%%-------------------------------------------------------------------
-module(distributed_messenger_v_2).
-author("phiri").

%% API
-export([start_server/0, server/0, logon/1, logoff/0, message/2, client/2]).
server_node() ->
  server_node(super).

server_node(Name) ->
  case Name of
    bilbo -> 'bilbo@127.0.0.1';
    gollum -> 'gollum@127.0.0.1';
    kosken -> 'kosken@127.0.0.1';
    super -> 'super@127.0.0.1';
    _ -> 'deadletter@127.0.0.1'
  end .

%%% This is the server process for the "messenger"
%%% the user list has the format [{ClientPid1, Name1},{ClientPid22, Name2},...]
server() ->
  process_flag(trap_exit, true),
  server([]).

server(Users_List) ->
  receive
    {From, logon, Name} ->
      New_User_List = server_logon(From, Name, Users_List),
      server(New_User_List);
    {'EXIT', From , _ } ->
      New_User_List = server_logoff(From,Users_List),
      server(New_User_List);
    {From, message_to, To, Message } ->
      server_transfer(From, To, Message, Users_List) ,
      io:format("The list of users is now: ~p~n",[Users_List]) ,
      server(Users_List)
  end.

%%% starts the server
start_server() ->
  register(messenger, spawn(distributed_messenger_v_2, server, [])).

server_logon(From, Name, Users_List) ->
  %% check if user is logged on elsewhere
  case lists:keymember(Name,1,Users_List) of
    true ->
      From ! {messenger, stop, user_exists_at_other_node}, %% reject logon
      Users_List;
    false ->
      From ! {messenger, logged_on},
      link(From),
      [{From, Name} | Users_List ] %% add new user to the login list
  end.


server_logoff(From, User_List) ->
  lists:keydelete(From, 1, User_List).

%%% server transfers messages between two users
server_transfer(From, To , Message, User_List) ->
  %% check user who he is
  case lists:keysearch(From, 1, User_List) of
    false ->
      From ! {messenger, stop, you_are_not_logged_on} ;
    {value, {_, Name }} ->
      server_transfer(From, Name,To, Message, User_List)
  end.

%%% if the receiver exists, then send him a message
server_transfer(From, Name, To , Message, User_List) ->
  %% find the receiver snd send the message to him
  case lists:keysearch(To,2, User_List) of
    false ->
      From ! {messenger, receiver_not_found } ;
    {value,{ToPid, To}} ->
      ToPid ! {message_from, Name, Message} ,
      From ! {messenger, sent}

  end.

%%% User Commands

logon(Name) ->
  case whereis(mess_client) of
    undefined ->
      register(mess_client, spawn(distributed_messenger_v_2, client, [server_node(), Name])) ;
    _ -> already_logged_on
  end.

logoff() ->
  mess_client ! logoff.

message(ToName, Message) ->
  case whereis(mess_client) of % test if client is running
    undefined ->
      not_logged_on;
    _ -> mess_client ! { message_to, ToName , Message }
  end.

%%% The client process that run on each user node

client(Server_Node, Name) ->
  {messenger, Server_Node} ! {self(), logon, Name},
  await_result(),
  client(Server_Node).

%%% Wait for response from the server

client(Server_Node) ->
  receive
    logoff ->
      exit(normal);
    {message_to,ToName , Message } ->
      {messenger, Server_Node} ! {self(), message_to, ToName, Message} ,
      await_result();
    {message_from, FromName, Message } ->
      io:format("Message From ~p : ~p~n", [FromName, Message])
  end ,
  client(Server_Node).

await_result() ->
  receive
    {messenger, stop, Why } ->
      io:format("received a command to stop, reason: ~p~n",[Why]),
      exit(normal);
    {messenger, What} ->
      io:format("Received response from server: ~p~n",[What]) %% normal response from server
    after 5000 ->
      io:format("no response from server. exiting...~n"),
      exit(timeout)

  end.


