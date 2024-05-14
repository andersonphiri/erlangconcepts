%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. May 2024 09:13
%%%-------------------------------------------------------------------
-author("phiri").

-define(DWORD, 32/unsigned-little-integer).
-define(LONG, 32/unsigned-little-integer).
-define(WORD, 16/unsigned-little-integer).
-define(BYTE, 8/unsigned-little-integer).

unpack_image_resource_directory(Dir) ->
  <<Characteristics : ?DWORD,
    TimeDateStamp : ?DWORD,
    MajorVersion : ?WORD,
    MinorVersion : ?WORD,
    NumberOfNamedEntries : ?WORD,
    NumberOfIdEntries : ?WORD ,
    _/binary
  >> = Dir ,
  ok.

bit_comprehension() ->
  B = <<16#5F>>,
  BitsCo = [X || <<X:1>> <= B],
  BitsCo.