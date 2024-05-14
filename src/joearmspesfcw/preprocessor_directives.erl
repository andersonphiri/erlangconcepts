%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 4月 2024 13:55
%%%-------------------------------------------------------------------
-module(preprocessor_directives).
-author("phiri").

%% API
-export([test_prep_directive/1]).

-ifdef(debug).
-define(LOG(X), io:format("{~p,~p}: ~p~n", [?MODULE_STRING,?LINE,X])).
-else.
-define(LOG(X), true).
-endif.

%% The you compile as: erlc -Ddebug preprocessor_directives.erl
test_prep_directive(Info) ->
  ?LOG(Info).


%% conditional code execution
-ifdef(OTP_RELEASE).
-if(?OTP_RELEASE >= 22).
  %% code that will work with OTP 20 or higher
-elif(?OTP_RELEASE >= 21).
  %% code that will work with OTP 20 or higher
-endif.



-else.
  %%% OTP 20 or lower
-endif.


%% throw a compilation error
-define(VERSION, "").
-ifdef(VERSION).
version() -> ?VERSION.
-else.
-error("Macros version must be defined").
-warning()
version() -> "".
-endif.


%% stringifying macro arguments:
-define(TESTCALL(Call), io:format("Call ~s: ~w~n",[??Call, Call])).

