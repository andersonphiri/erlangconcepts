%%%-------------------------------------------------------------------
%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%% this module tests interaction with mnesia
%%% @end
%%% Created : 31 May 2024 by anderson phiri <andersonp@generictechnologie.com>
%%%-------------------------------------------------------------------
-module(test_mnesia).
-include("test_mnesia.hrl").

-export([initialize_db/0, add_cost_item/2, add_shop_item/3]).
initialize_db() -> 
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
    mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
    mnesia:stop().

add_shop_item(Name, Quantity, Cost) ->
    Row = #shop{item = Name, cost = Cost, quantity=Quantity}  ,
    F = fun() -> 
            mnesia:write(Row) 
        end,
    mnesia:transaction(F).
add_cost_item(Name, Price) ->
    Row = #cost{name = Name, price = Price}  ,
    F = fun() -> 
            mnesia:write(Row) 
        end,
    mnesia:transaction(F).

