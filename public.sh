#!/bin/bash

# public shell script for other scripts use
# contain:
# 1. download zip package to tools directory
# 2. untar the package to destination
# 3. compile and install software by resource
# 4. add executive file to PATH
# 5. link executive file to PATH bin


BASHFILE="$HOME/.bashrc"
ZSHFILE="$HOME/.zshrc"
DEFAULT_SOFTWARE_PATH="/opt/tools/"
DEFAULT_SOFTWARE_DIRS="compressed_packages resource_files"

# split lines
# accept one param of split char
function splitline()
{
    s=$(printf "%-80s" "$1")
    echo "${s// /$1}"
}

# verify given path satisfied to path regex
# parameter will be the path to be verified
function verifyPath()
{
    local regex='^(/{1,2}[0-9|a-z|\.|_|\-]+)+/?$'
    if [[ "$1" =~ $regex ]];then
        return 0
    else
        return 1
    fi
}

# verify if function proceed successfully
# given two parameters are
# 1. for the function return status code
# 2. is the message to print out
function verify()
{
    if test $1 -ne 0;then
        echo "errors occur during $2"
        exit 1
    fi
}

# download resource package
# given two parameters are
# 1. the url of download resource website
# 2. the package name for download
function download()
{
    local url=$1
    local package=$2
    local path="$DEFAULT_SOFTWARE_PATH"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')
    if [[ -z $package ]] || [[ -z $url ]];then
        echo "package or url parameter is NULL, exit!"
        return 1
    fi
    
    if [[ ! -e "$path/$package" ]];then
        wget -P $path "$url$package"
        verify $? "downloading package $package!"
        echo "download $package finish!"
        return 0
    fi
    echo "package exists, no need to download again!"
    return 0
}

# echo log message
# 1. function name
# 2. msg
# 3. type
function echoLog()
{
    
    echo "[$3] public.sh/$1 : $2 [$3]"

}


# untar the package to specific path
# given two parameters are
# 1. package name to untar $1
# 2. target path to untar package $2
#    if it's null, resource path instead
function untarPackage()
{   
    if [[ -z $1 ]];then
        echoLog "UntarPackage" "Required parameter package name is absent!" "ERROR"
        return 1
    fi
    # init path with default path
    local target_path="$DEFAULT_SOFTWARE_PATH"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $2}')
    # if there is given path, dont use default one
    if test -n "$2";then
        verifyPath "$2"
        if test $? -ne 0;then
            echoLog "UntarPackage" "Given path is unavailable!" "ERROR"
            return 1
        fi
        target_path="$2"
    fi
    local package_path="$DEFAULT_SOFTWARE_PATH"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')"/$1"
    echoLog "UntarPackage" "Untaring parameters { target_path : $target_path, package_path : $package_path }" "ERROR"
    if [[ ! -f "$package_path" ]];then
        echo "given package $1 is not existed in default software path $DEFAULT_SOFTWARE_PATH"$(echo $DEFAULT_SOFTWARE_DIRS | awk '{print $1}')
        return 1
    fi
    tar -xf "$package_path" -C $target_path
    verify $? "untaring package $package_path!"
    return 0
}

# add env variable to path
# given two parameters are
# 1. content need to be added to file
# 2. path of file to be added and sourced
function addPath()
{   
    printf "$1" >> "$2"
    source "$2"
}

# mk dirs for given dirs if they are not exist
# given two parameters are
# 1. given path, e.g: /opt/tool
# 2. given dirs, e.g: src or pkg
function makeDirs()
{
    local path=$1
    local dirs=$2
    for var in ${dirs[*]}; do
        local fullpath="$path/$var"
        verifyPath "$fullpath"
        if [[ $? -ne 0 ]];then
            echo "given path and directories make up fullpath $fullpath error, please check!"
            continue
        fi
        if [[ ! -d "$fullpath" ]];then
            mkdir -p "$fullpath"
            echo "create directory $fullpath successfully!"
        else
            echo "directory $fullpath exists, no need to create!"
        fi
    done
}

# add soft link from a to b
# given two parameters are
# 1. from position
# 2. target position
function addLink()
{
    ln -s "$1" "$2"
    verify $? "soft link creation with param { \$1:$1, \$2:$2}!"
}

makeDirs "$DEFAULT_SOFTWARE_PATH" "$DEFAULT_SOFTWARE_DIRS"