%%%------ FILE user_interface.erl-------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2024 05:30
%%%-------------------------------------------------------------------
-module(user_interface).
-author("phiri").

%% API
-export([logon/1, logoff/0, message/2]).

-include("mess_config.hrl").
-include("mess_interface.hrl").


logon(Name) ->
  case whereis(mess_client) of
    undefined ->
      register(mess_client, spawn(mess_client, client, [?server_node, Name]));
    _ -> already_logged_on
  end.

logoff() ->
  mess_client ! logoff.

message(ToName, Message) ->
  case whereis(mess_client) of
    undefined ->
      not_logged_on;
    _ -> mess_client ! #message_to{message = Message, to_name = ToName},
      ok
  end.

%%%------ END OF FILE user_interface.erl -----------------------------------