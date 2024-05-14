%%%---- FILE mess_server.erl ---------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2024 23:14
%%%-------------------------------------------------------------------
-module(mess_server).
-author("phiri").

%% API
-export([]).

-include("mess_interface.hrl").

%%% This is the server process of the messenger service

%%% This is the server process for the "messenger"
%%% the user list has the format [{ClientPid1, Name1},{ClientPid22, Name2},...]
server() ->
  process_flag(trap_exit, true),
  server([]).

%%% the user list has the format [{ClientPid1, Name1},{ClientPid22, Name2},...]
server(Users_List) ->
  receive
    #logon{client_pid = From , username = Name } ->
      New_User_List = server_logon(From, Name, Users_List),
      server(New_User_List);
    {'EXIT', From , _ } ->
      New_User_List = server_logoff(From,Users_List),
      server(New_User_List);
    #message{client_pid = From, to_name = To , message = Message} ->
      server_transfer(From, To, Message, Users_List) ,
      io:format("The list of users is now: ~p~n",[Users_List]) ,
      server(Users_List)
  end.

%%% starts the server
start_server() ->
  register(messenger, spawn(?MODULE, server, [])).

server_logon(From, Name, Users_List) ->
  %% check if user is logged on elsewhere
  case lists:keymember(Name,1,Users_List) of
    true ->
      From ! #abort_client{message = user_exists_at_other_node}, %% reject logon
      Users_List;
    false ->
      From ! #server_reply{message = logged_on},
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
      From ! #abort_client{message = you_are_not_logged_on} ;
    {value, {_, Name }} ->
      server_transfer(From, Name,To, Message, User_List)
  end.

%%% if the receiver exists, then send him a message
server_transfer(From, Name, To , Message, User_List) ->
  %% find the receiver snd send the message to him
  case lists:keysearch(To,2, User_List) of
    false ->
      From ! #server_reply{ message = receiver_not_found }  ;
    {value,{ToPid, To}} ->
      ToPid ! #message_from{from_name = From, message = Message} ,
      From ! #server_reply{message = sent}

  end.


%%%---- EOF mess_server.erl -------------------------