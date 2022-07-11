#!/bin/bash

# 一键更新 多项目多分支
# 父文件夹下多分支文件夹，如v1.0 v2.0 v3.0等，每个分支文件夹下多个项目

ENTRANCE_POSITION=$(pwd)
FLAG=0
FINAL_CHOICE=""

# 分割线
function splitline()
{
    s=$(printf "%-80s" "$1")
    echo "${s// /$1}"
}

# 提示
function notify()
{   echo "该脚本将递归更新选择目录下项目的主库代码！"
    splitline "*"
}

# 获取目录下的文件夹列表
function getDirectoriesUnderPath(){
    echo $(ls -l $1 | grep "^d" | awk '{print $9}')
}

# 获取选择的文件夹名称
function getChoice(){
    local length=$1
    local dirs=$2
    if test $FLAG -eq 0;then
        read -p "请选择目录索引：" choice
    else
        read -p "选择为空或选择有误，请重新选择：" choice
    fi
    if [[ -z $choice ]] || [[ ! $choice =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $length ]];then
        FLAG=1
        getChoice $length "${dirs[*]}"
    else
        FINAL_CHOICE=$(echo $dirs | awk -v n=$choice '{print $n}')
    fi
}

# 展示当前路径下可选选项
function showDirectories()
{
    # 展示目录可选项
    local dirs=$(getDirectoriesUnderPath $(pwd))
    local count=1
    for dir in ${dirs[*]};
    do
        echo "[$count]    $dir"
        count=$(($count + 1))
    done
    # 获取有效选项用来
    # 返回文件夹选项
    splitline "*"
    getChoice $(($count - 1)) "${dirs[*]}"
}

# 进行更新
function updateProjects(){
    local path="$ENTRANCE_POSITION/$FINAL_CHOICE"
    cd $path
    local dirs=$(getDirectoriesUnderPath $path)
    for dir in ${dirs[*]};
    do  
        splitline "*"
        if [[ ! -d "$path/$dir/.git" ]];then
            echo "当前$dir项目并非Git项目，无法更新"
            continue
        fi
        cd $dir
        local branch=$(git branch | grep '*'| awk '{print $2}')
        echo "当前$dir项目分支为$branch"
        # 更新
        local cmd="git pull origin $branch"
        echo $cmd
        $cmd
        if test $? -ne 0;then
            echo "更新项目失败，请检查授权或手动清除文件冲突！"
        else
            echo "更新项目成功！"
        fi
        cd ..
    done
}

function main(){
    notify
    showDirectories
    updateProjects
}

main