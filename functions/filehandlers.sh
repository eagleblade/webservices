#!/bin/bash
function check_file(){
    if [ -f "$1" ]; then
    return 0
    else
    return 1
fi
}

function check_folder(){
    if [ -d "$1" ]; then
    return 0
    else
    return 1
fi
}

function create_file(){
    if check_file $1; 
        then 
    :
        else
    touch $1
    fi
}

function create_folder(){
    if check_folder $1; 
        then 
    :
        else
    mkdir $1
    fi
}

function clear_file(){
    cat /dev/null > $1
}
function clear_folder(){
    rm -fr $1
}