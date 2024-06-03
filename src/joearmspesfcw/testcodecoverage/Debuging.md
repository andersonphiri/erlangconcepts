### How to debug


#### How to debug your module

- recompile the module with debug_info option: <code>erlc +debug_info Module.erl</code> OR in the erlang shell <code>c(ModuleName,[debug_info]).</code>
- start the erlang shell <code>erl</code>
- `im().` will start a new graphical monitor, the main window of the debugger <br />
`<0.44.4>`
- `ii(working_with_files).` means interpret any code in the module working_with_files<br />
`{module,working_with_files}` <br />
- `iaa([init]).` attach the debugger to any process executing interpretted code when that process is started.<br />
`true`

- all the function are found in the i module. The debugger/interpreter interface : https://www.erlang.org/doc/apps/debugger/i.html 
- <code>
6> i:
help/0     &npsp;    ia/1           ia/2           ia/3           ia/4
iaa/1          iaa/2          ib/2           ib/3           ib/4
iba/3          ibc/3          ibd/2          ibe/2          ic/0
ii/1           ii/2           il/0           im/0           ini/1
ini/2          inq/1          ip/0           ipb/0          ipb/1
iq/1           ir/0           ir/1           ir/2           ir/3
ist/1          iv/0           module_info/0  module_info/1
6> i:
</code>


#### Tracing 

- user erlang:trace(PidSpec, How, FlagList):
    - this will start tracing. PidSpec will tell the system what to trace. How is a boolean to turn the trace on or off
    - FlagList governs what is to be traced 
    - The process that calls this bif will be sent trace messages when trace events occurs
- erlang:trace({M,F,A}, MatchSpec, FlagList)
    - this is used to set a tracing pattern 


- for more, look at the following modules: <code>dbg</code>  <br />
- <code>ttb</code> <br />
- <code>ms_transform</code> <br />
