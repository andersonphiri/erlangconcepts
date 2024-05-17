### Client and server on different hosts in the internet

#### take the following steps 

- make sure port 4369 is open for tcp and udp traffic. This port is used by epmd
- choose a port or range of ports to be used for distributed erlang, and make sure these ports are open
- these ports are Min and Max, or use Min only if you want to use a single port
- For example if we need to use port range from port 4375 to 4385
- <code>erl -name ... -setcookie ... -kernel inet_dist_listen_min 4375 inet_dist_listen_max 4385</code>


#### Sending message 

- send can be used to send messages to a locally registered process in a set of distributed erlang nodes
- with the following syntax
- <code>{RegName, Node} ! Msg</code> will send the message Msg to a registered process with name RegName on node Node
