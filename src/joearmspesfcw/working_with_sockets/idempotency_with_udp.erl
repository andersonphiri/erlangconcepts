%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. May 2024 09:43
%%%-------------------------------------------------------------------
-module(idempotency_with_udp).
-author("phiri").
-export([add_server_udp/1, add_list/1, add_client_udp/2]).
add_server_udp(Port) -> 
    {ok, Socket} = gen_udp:open(Port, [binary]),
    io:format("server started on port: ~p, (~p)~n",[Port, Socket]),
    loop(Socket). 

loop(Socket) -> 
    receive
        {udp, Host, Port, Bin} -> 
            ClientRequestDecoded = binary_to_term(Bin),
            io:format("server decoded client's request: ~p~n",[ClientRequestDecoded]),
            {_,RequestId, _, _}  = ClientRequestDecoded,
            case ClientRequestDecoded of
                {iid,Iid, add, Nums} when is_list(Nums) ->
                    Computed = {Iid,add_list(Nums)} ,
                    ComputedBin = term_to_binary(Computed),
                    gen_udp:send(Socket, Host, Port, ComputedBin);

                Other -> 
                    io:format("unknown client command: ~p~n", [Other]),
                    gen_udp:send(Socket, Host, Port, term_to_binary({error_unknown_command,RequestId, Other}))

                    
            end
    end.


add_list([]) -> 0;
add_list(Nums) -> lists:foldl(fun(Elem, AccIn) -> Elem + AccIn end, 0, Nums).

add_client_udp(Port,{Operation, Input}) -> 
    {ok, Socket} = gen_udp:open(0, [binary]),
    RequestIid = make_ref(),
    io:format("client's request id: ~p~n",[RequestIid]),
    Request = {iid,RequestIid,Operation,Input},
    BinaryRequest = term_to_binary(Request),
    io:format("client binary request: ~p~n",[BinaryRequest]),
    ok = gen_udp:send(Socket, "localhost", Port, BinaryRequest),
    loop(Socket,RequestIid).
    

loop(Socket,RequestIid) -> 
    receive
        {udp,Socket,  _,_, Bin} -> 
            case binary_to_term(Bin) of
                {RequestIid,Results} -> Results;
                {error_unknown_command,_,_ } -> error_unknown_command;
                Other -> Other
                    
            end
        after 6000 ->
        error_server_timeout
        end,
    
    gen_udp:close(Socket).



