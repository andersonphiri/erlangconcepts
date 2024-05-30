%%%-------------------------------------------------------------------
%%% @author anderson phiri <andersonp@generictechnologie.com>
%%% @copyright (C) 2024, anderson phiri
%%% @doc 
%%%
%%% @end
%%% Created : 30 May 2024 by anderson phiri <andersonp@generictechnologie.com>
%%%-------------------------------------------------------------------
-module(lib_trigrams).

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


foreach_trigram_in_the_english_language(F, A0) -> 
    {ok, Bin0} = file:read_file("354984si.ngl.gz"),
    Bin = zlib:gunzip(Bin0),
    scan_word_list(binary_to_list(Bin), F, A0).



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
    


%%% Table building logic 

