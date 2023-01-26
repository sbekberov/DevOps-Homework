#!/bin/bash
arpGrep () {
  echo "$(arp $1 | tail -n 1 | awk '{print $1}')"
}

displayIPaddresses () {
  if [[ `/usr/bin/which nmap` ]]
  then 
    subnetip="$(sudo nmap -sP -n $(ip -o address | awk '/scope global/ {print $4}' | \
     head -n 1) | awk '/Nmap scan/ {print $5}')"
    for ip in $subnetip
    do
      echo "$ip [$(arpGrep $ip)]"
    done
  else
    echo "To run this script you have to install \"nmap\""
  fi
}


displayPorts () {
  if [[ `/usr/bin/which netstat` ]]
  then
    echo "$(sudo netstat -tlpn | grep LISTEN | awk '{print $1,$4}')"
  else
    echo -e "To run this script you have to install \"netstat\""
  fi
}


main () {

  MESSAGE="You have to use one parameter:\n
--all - to display IP addresses and symbolic names of all hosts in the current subnet\n
--target  - to display a list of open system TCP ports"

  case "$1" in
     --all) displayIPaddresses;;
  --target) displayPorts;;
         *) echo -e $MESSAGE
  esac
}

main $1
