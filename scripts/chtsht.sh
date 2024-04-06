#!/bin/bash


if [  $# -eq 0 ] 
    then
    # provide a list of options
    CHOICE=$(echo $'search\nlearn\ncheatsheet'| fzf)
    echo $CHOICE
    if [ $CHOICE = "search" ] 
    then
        echo -n "enter program: "
        read
        p=$REPLY
        echo -n "enter search term: "
        read
        t=$REPLY

        curl cheat.sh/$p~$t | less
    elif [ $CHOICE = "learn" ]
    then
        echo -n "Enter Programming Language: "
        read 
        curl cheat.sh/$REPLY/:learn | less -R
       
    elif [ $CHOICE = "cheatsheet" ] 
    then
        echo -n "Enter a thing you want to cheat: "
        read
        curl cheat.sh/$REPLY | less -R
    else
        echo "Someone messed up!!!"
    fi
    
        

    exit
fi

if [ $# -eq 1 ] 
then
    curl cheat.sh/$1 | less
    exit
elif [ $# -eq 1] 
then
    # parse the input 
    echo "Parse!!!"
    exit
else
    # no clue!!
    echo "Don\'t know what you want ?? " 
    echo "Please provide a clear goal"
fi


