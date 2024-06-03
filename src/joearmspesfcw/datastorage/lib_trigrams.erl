%%%-------------------------------------------------------------------
%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 30 May 2024 by anderson phiri <andersonp@generictechnologie.com>
%%%-------------------------------------------------------------------
-module(lib_trigrams).
-export([foreach_trigram_in_the_english_language/2,
make_tables/0, timer_tests/0,
open/0, close/1, is_word/2,
how_many_trigrams/0, 
make_ets_set/0, make_ets_ordered_set/0, make_mod_set/0,
lookup_all_ets/2, lookup_all_set/2

]).
-import(lists, [reverse/1]).



get_next_word([$\r,$\n|T], L) -> {reverse([$\s|L]), T};
get_next_word([H | T], L) -> get_next_word(T, [H|L]);
get_next_word([], L) -> {reverse([$\s|L]), []}.

scan_word_list(L,F,A) -> 
    {Word, L1} = get_next_word(L, []),
    A1 =  scan_trigrams([$\s | Word], F, A),
    scan_word_list(L1, F,A1).



scan_trigrams([X,Y,Z], F, A) -> 
    F([X,Y,Z], A);

scan_trigrams([X,Y,Z | T], F, A) ->
    A1 = F([X,Y,Z], A),
    scan_trigrams([Y,Z | T], F, A1);

scan_trigrams(_, _, A) -> A.


%%% a foreach loop accepting an apply function and the accumulator inital. willreturn the final accumulator
foreach_trigram_in_the_english_language(F, A0) -> 
    {ok, Bin0} = file:read_file("354984si_new.ngl.gz"),
    io:format("file 354984si_new.ngl.gz opening was successful..~n"),
    Result = unzip_files(Bin0),
    case Result of 
        {'EXIT',{Reason, StackTrace}} -> 
            io:format("error executing gunzip, Reason: ~p~n Stack Trace: ~p~n",[Reason,StackTrace]),
            exit(unzip_failed);
        _ when is_binary(Result) -> 
            io:format("unzip was successful"),
            scan_word_list(binary_to_list(Result), F, A0)
    end.
    
unzip_files(Binary) -> 
    Z = zlib:open(),
    Bs = try 
            ok = zlib:inflateInit(Z, -15),
            B = zlib:inflate(Z, Binary),
            ok = zlib:inflateEnd(Z),
            B
         after
             zlib:close(Z)
         end,
    iolist_to_binary(Bs).


%%% Sets creation logic


make_a_set(Type, FileName) -> 
    Table = ets:new(table, [Type]),
    F = fun(Str, _) -> ets:insert(Table, {list_to_binary(Str)}) end,
    foreach_trigram_in_the_english_language(F, 0),
    ets:tab2file(Table, FileName),
    Size = ets:info(Table, size),
    ets:delete(Table),
    Size.

make_mod_set() -> 
    D = sets:new(),
    F = fun(Str, Set) -> 
            sets:add_element(list_to_binary(Str), Set) 
        end,
    D1 = foreach_trigram_in_the_english_language(F, D),
    file:write_file("trigrams.set", [term_to_binary(D1)]).



    timer_tests() ->
        time_lookup_ets_set("Ets ordered Set", "trigramsOS.tab"),
        time_lookup_ets_set("Ets set", "trigramsS.tab"),
        time_lookup_module_sets().
    
    time_lookup_ets_set(Type, File) ->
        {ok, Tab} = ets:file2tab(File),
        L = ets:tab2list(Tab),
        Size = length(L),
        {M, _} = timer:tc(?MODULE, lookup_all_ets, [Tab, L]),
        io:format("~s lookup=~p micro seconds~n",[Type, M/Size]),
        ets:delete(Tab).
    
    lookup_all_ets(Tab, L) ->
        lists:foreach(fun({K}) -> ets:lookup(Tab, K) end, L).
    
time_lookup_module_sets() ->
    {ok, Bin} = file:read_file("trigrams.set"),
    Set = binary_to_term(Bin),
    Keys = sets:to_list(Set),
    Size = length(Keys),
    {M, _} = timer:tc(?MODULE, lookup_all_set, [Set, Keys]),
    io:format("Module set lookup=~p micro seconds~n",[M/Size]).
    


make_ets_ordered_set() -> make_a_set(ordered_set, "trigramsOS.tab").

make_ets_set() -> make_a_set(set, "trigramsS.tab").


%%% lookup logic 

is_word(Tab, Str) -> is_word1(Tab, "\s" ++ Str ++ "\s").
is_word1(Tab, [_,_,_] = X) -> 
    is_this_a_trigram(Tab, X);
is_word1(Tab, [A, B, C | D]) -> 
    case is_this_a_trigram(Tab, [A,B,C]) of 
        true -> is_word1(Tab, [B,C |  D]) ;
        false -> false
    
    end;
is_word1(_,_) -> 
    false.


is_this_a_trigram(Tab, X) -> 
    case ets:lookup(Tab, list_to_binary(X)) of 
        [] ->  false;
        _ -> true
    end.

lookup_all_set(Set, L) -> 
    lists:foreach(fun(Key)  -> sets:is_element(Set, Key) end, L). 

how_many_trigrams() -> 
    F = fun(_, N) -> 1 + N end,
    foreach_trigram_in_the_english_language(F, 0).



%%% Table building logic 

make_tables() ->
    {Micro1, N} = timer:tc(?MODULE, how_many_trigrams, []),
    io:format("Counting - No of trigrams=~p time/trigram=~p~n",[N,Micro1/N]),
    {Micro2, Ntri} = timer:tc(?MODULE, make_ets_ordered_set, []),
    FileSize1 = filelib:file_size("trigramsOS.tab"),
    io:format("Ets ordered Set size=~p time/trigram=~p~n",[FileSize1/Ntri, 
			 			           Micro2/N]),
    {Micro3, _} = timer:tc(?MODULE, make_ets_set, []),
    FileSize2 = filelib:file_size("trigramsS.tab"),
    io:format("Ets set size=~p time/trigram=~p~n",[FileSize2/Ntri, Micro3/N]),
    {Micro4, _} = timer:tc(?MODULE, make_mod_set, []),
    FileSize3 = filelib:file_size("trigrams.set"),
    io:format("Module sets size=~p time/trigram=~p~n",[FileSize3/Ntri, Micro4/N]).
open() -> 
    File = filename:join(filename:dirname(code:which(?MODULE)), "/trigramsS.tab"),
    {ok, Tab} = ets:file2tab(File),
    Tab.

close(Tab) -> ets:delete(Tab).
