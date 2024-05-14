%%%-------- FILE mess_interface.hrl -----------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2024 05:05
%%%-------------------------------------------------------------------
-author("phiri").

%%% Message interface between the server, the client and the client shell
%%% for the messenger program


%%% Messaged from client to server received in the server/1 function
-record(logon, {client_pid, username}).
-record(message, {client_pid, to_name, message}).

%%% {'EXIT', ClientPid, Reason} (client terminated or unreachable.
%%% Messages from Server to Client, received in await_result/0 function
-record(abort_client, {message}).

%%% Messages are: user_exists_at_other_node,
%%% you_are_not_logged_on

-record(server_reply, {message}).
%%% Messages are: logged_on
%%% receiver_not_found
%%% sent (Message has been sent (no guarantee)
%%% Messages from Server to Client received in client/1 function

-record(message_from, {from_name, message}).
%%% Messages from shell to Client received in client/1 function
%%% spawn(mess_client, client, [server_node(), Name])

-record(message_to, {to_name, message}).

%%%logoff

%%%%% -------- END FILE mess_interface.hrl --------------