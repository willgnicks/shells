#!/bin/bash

STRUCTURE=("src" "pkg" "bin")
PACKAGE="go1.18.3.linux-amd64.tar.gz"
INSTALL_TARGET="/usr/local/go"
PATH_NAME="/projects/go_projects"

NOTE="# set golang path"
GOROOT="export GOROOT=/usr/local/go"
GOPATH="export GOPATH=$HOME$PATH_NAME"
NEWPATH='export PATH=$PATH:$GOROOT/bin:$GOPATH/bin'
BASHFILE="$HOME/.bashrc"

# split line
function splitline()
{
    s=$(printf "%-80s" "$1")
    echo "${s// /$1}"
}

function verify()
{
    if test $1 -ne 0;then
        echo "error occurs during $2"
        exit 1
    fi
}

# untar package
function untarPackage()
{
    if test ! -e "$INSTALL_TARGET";then
        mkdir -p $INSTALL_TARGET
    fi
    tar -xf "$HOME/$PACKAGE" -C $INSTALL_TARGET --strip-components 1
    verify $? "untaring"
    echo "untar package finish!"
}

# download resource package
function download()
{   
    if test ! -e "$HOME/$PACKAGE";then
        wget -P $HOME "https://golang.google.cn/dl/$PACKAGE"
        verify $? "downloading"
        echo "download finish!"
        return
    fi
    echo "package exists!"
}

# add env variable to path
function addPath()
{   
    if test ! -d "$HOME$PATH_NAME";then
        for dir in ${STRUCTURE[*]};do
            mkdir -p "$HOME$PATH_NAME/$dir"
        done
    fi
    printf "$NOTE\n$GOROOT\n$GOPATH\n$NEWPATH" >> $BASHFILE
    source $BASHFILE
    echo "set path finish!"
    splitline "="
}

function main()
{   
    splitline "="
    download
    splitline "="
    untarPackage
    splitline "="
    addPath
}

main