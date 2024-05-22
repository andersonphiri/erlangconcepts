-file("hello_world.erl", 1).

-module(hello_world).

-author("phiri").

-file("world.hrl", 1).

-author("phiri").

-file("hello_world.erl", 11).

-export([hello/0]).

hello() ->
    "hellow world...".



