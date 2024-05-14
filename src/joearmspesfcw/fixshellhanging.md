### The shell isn't responding 

- running the following will cause the shell to hang:
- <code>$: receive foo ->  true end.</code>
- why? because the shell is waiting for a message foo which is never send
#### The fix

- Press ctrl+g or ^G. The shell will go into JCL(Job Control Language) mode
- next press h - to list available options 
- press j to list running jobs 
- press s to start another local shell
- press j again
- c <N> to connect to job N. job N has no [init] or is highlighted as active by *asterisk
- then type: <code>1> init:stop() <br />ok </code>



### crush dump analyzer

- when erlang crashes, it leaves a file erl_crash.dump
- to view, run<code>crashdump_viewer:start()</code>


### Getting Help 

- <code>$> erl -man erl</code>
- <code>$> erl -man lists</code>

### Tweaking environment 

- The command <code>$> help().</code> will list all built-in commands
- all these commands are found in the shell_default module
- however, to add your own, create a module called user_default and include this in the search path when starting erl



### Increase max allowed number of processes 

- <code>$ erl +P 3000000</code>
- Then look for allowed number: <code> 1> erlang:system_info(process_limit).</code>