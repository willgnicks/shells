#!/bin/bash

# 一键更新 多项目多分支
# 父文件夹下多分支文件夹，如v1.0 v2.0 v3.0等，每个分支文件夹下多个项目

branch=""
position=$(pwd)
dirs=$(ls -l | grep "^d" | awk '{print $9}')
flag=0

function getChoice(){
    local length=$1
    if test $flag -eq 0;then
        read -p "请选择目录索引：" choice
    else
        read -p "选择为空或选择有误，请重新选择：" choice
    fi
    if [ -z $choice ] || [[ ! $choice =~ ^[0-9]+$ ]] || [ $choice -lt 1 ] || [ $choice -gt $length ];then
        flag=1
        getChoice $length
    else
        echo $dirs | awk -v n=$choice '{print $n}'
    fi
}

function showDirsAndGetDir(){
    # 展示目录可选项
    local count=1
    for dir in ${dirs[*]};
    do
        echo "[$count]  $dir"
        count=$(($count + 1))
    done
    # 获取有效选项用来
    # 返回文件夹选项
    echo $(getChoice $(($count - 1)))
}

function getBranch(){
    local dir=$1
    cd "$pwd/$dir"
    local ds=$(ls -l | grep "^d" | awk '{print $9}')
    for d in ${ds[*]};
    do{
        cd $d
        branch=$(get branch | awk '{print $2}')
        git pull origin $branch
    }&
    done
}


# function update(){

# }

function main(){
    local dir=$(showDirsAndGetDir)
    getBranch $dir
    update
}

main