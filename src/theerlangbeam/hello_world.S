{module, hello_world}.  %% version = 0

{exports, [{hello,0},{module_info,0},{module_info,1}]}.

{attributes, [{author,"phiri"},{author,"phiri"}]}.

{labels, 7}.


{function, hello, 0, 2}.
  {label,1}.
    {line,[{location,"hello_world.erl",15}]}.
    {func_info,{atom,hello_world},{atom,hello},0}.
  {label,2}.
    {move,{literal,"hellow world..."},{x,0}}.
    return.


{function, module_info, 0, 4}.
  {label,3}.
    {line,[]}.
    {func_info,{atom,hello_world},{atom,module_info},0}.
  {label,4}.
    {move,{atom,hello_world},{x,0}}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 6}.
  {label,5}.
    {line,[]}.
    {func_info,{atom,hello_world},{atom,module_info},1}.
  {label,6}.
    {move,{x,0},{x,1}}.
    {move,{atom,hello_world},{x,0}}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.
