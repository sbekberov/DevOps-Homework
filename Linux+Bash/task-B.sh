#!/bin/bash

param=$1

topIp () {
    echo "1. From which ip were the most requests?"
    local result=$(awk '{print $1}' $param | sort | uniq -c | sort -nr | awk '{print "From IP " $2 "\t were " $1 " requests" }' | head -n 1)
    echo -e "$result\n"
}

topPages () {
    echo "2. What is the most requested page?"
    result=$(cat $param | cut -d\" -f2 | awk '{print $2}'|grep "html" | sort | uniq -c | sort -nr | head -20)
    echo -e "$result\n"
}

requestsCount () {
    echo "3. How many requests were there from each ip?"
    result=$(awk '{print $1}' $param | sort | uniq -c | sort -nr | awk '{print "From IP " $2 "\t were " $1 " requests" }')
    echo -e "$result\n"
}

nonExistPages () {
    echo "4. What non-existent pages were clients reffered to?"
    result=$(cat $param | grep " 404 " | cut -d\" -f2 | awk '{print $2}' | sort | uniq)
    echo -e "$result\n"
}

topTimeRequests () {
    echo "5. What time did site get the most requests?"
    result=$(cat $param | cut -d [ -f2 | cut -d] -f1 | awk -F: '{print $2":00-"$2":59"}' | uniq -c | sort -nr | awk '{ print "Site get " $1 " requests at " $2}')
    echo -e "$result\n"
}

findBots () {
    echo "6. What search bots have accessed the site (UA + IP)?"
    res=$(cat $param |  awk '/bot/{print $4,$(NF-1),$1}' | sort | uniq | tr -d ";" | tr -d \" | tr -d \[ | grep -i "bot" ) 
    result=$(cat $param |  awk '/bot/{print $4,$12,$1}' | sort | uniq | tr -d ";" | tr -d \" | tr -d \[ |grep -i "bot" )
    echo -e "$result"
    echo -e "$res"
}


if [[ $# -ne 1 ]]
then
    echo -e "You have to run script with path to file as argument."
else
    topIp
    topPages
    requestsCount
    nonExistPages
    topTimeRequests
    findBots
    
fi
