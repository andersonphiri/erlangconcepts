%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. May 2024 09:07
%%%-------------------------------------------------------------------
-module(json_test).
-author("phiri").
-compile({parse_transform, json_parser}).
%% API
-export([test/1]).

test(V) ->
  <<{{
    "name"  : "Jack (\"Bee\") Nimble",
    "format": {
      "type"      : "rect",
      "widths"     : [1920,1600],
      "height"    : (-1080),
      "interlace" : false,
      "frame rate": V
    }
  }}>>.


