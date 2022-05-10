#!/bin/bash

# 可修改成其他git仓库的对应头
readonly head="git@github.com:"
readonly tail=".git"
readonly read_branch="请输入分支名称 ："
readonly read_account="请输入识别账户 ："
readonly branch_theme="分支名称"
readonly account_theme="识别账户"
branch=""
account=""
fullpath=""

# 修改.git配置
# function amend()
# {
# }

# 提示信息
function notify()
{
echo "## github多项目下载脚本 ##"
echo "## 该脚本仅针对同时具有fork库和主库的git远程仓库情况使用 ##"
printf "使用说明：\n1、已经配置好本地和github互信，github已经fork其他主库项目\n"
echo "2、请将主库地址配置文件放置该脚本同级目录中，配置文件中将多项目地址逐条保存；"
echo "3、脚本将设置fork库为默认库，主库为同步代码使用"
}

# 校验配置文件
function readConfig()
{
    read -p "请输入仓库配置文件名称 ：" config
    fullpath=$(pwd)"/$config"
    if [ ! -e $fullpath ] 
    then
        echo "文件不存在，请核对路径及文件名。程序退出！"
        exit
    fi
}

# 重复循环录入
function repeats()
{   
    local notion=$1
    local theme=$2
    read -p "${notion}" input
    while [ -z "$input" ]
    do
        read -p "输入${theme}为空，请重新输入${theme} ：" input
    done
    echo "$input"
}

# 获取键入信息并核对
function reads()
{   
    # 重复获取分支名，直至不为空
    branch=$(repeats "$read_branch" "$branch_theme")
    # 重复获取用户名，直至不为空
    account=$(repeats "$read_account" "$account_theme")
    # 提示确认是否使用该分支名和用户名
    printf "指定分支名：$branch;\t指定识别账户：$account;\n"
    # y确定 n取消重新输入 其他输入错误
    confirm
}

# 确认信息
function confirm()
{   
    # 首次提示确信并读取
    read -p "请确认信息是否正确 [ y 确定 / n 撤销 ] ? ：" answer
    # 输入空或输入不为y，一直循环
    while [ -z "$answer" -o "$answer" != "y" ]
    do  
        # 确认撤销，则重置信息，退出循环至信息录入
        if [ "$answer" == "n" ] 
        then
            echo "已撤销输入内容，请重新跟随提示输入！"
            echo "===================="
            branch=""
            account=""
            reads
            break
        else
            read -p "输入有误，请重新确认信息 [ y 确定 / n 撤销 ] ：" answer
        fi
    done
}

# 添加仓库
function addRepo()
{   
    local pro=$1
    echo "${pro}项目添加fork库仓库地址及修改配置文件程序开始"
    # git@github.com:willgnicks/QvPlugin-Trojan.git
    local cmd="git remote add fork $head$account/$pro$tail"
    cd $pro
    $cmd
    cd .git
    local amd="sed -i 's/remote = origin/remote = fork/'"
    $amd
    cd ../..
    echo "$pro项目添加fork库仓库地址及修改配置文件程序结束"
}

# 下载函数
function download()
{
    local start=$(date +%s)
    # 读取配置文件 拼接命令 下载主库
    local count=$(awk 'END{print NR}' $fullpath)
    for((i=1;i<$count;i++));
    do
        local address=$(sed -n ${i}p $fullpath)
        local project=$(echo ${address} | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')
        echo "项目${project}下载开始，当前进度 $i / $count ｜ 状态：开始"
        # 下载
        # git clone --progress --branch 
        local cmd="git clone --progress --branch ${branch} $address"
        $cmd
        if [ $? -eq 0 ] 
        then
            echo "clone项目成功，clone结束"
            addRepo $project
        else
            echo "clone项目失败，请核对授权及地址"
            continue
        fi
        echo "项目${project}下载开始，当前进度 $i / $count ｜ 状态：完成"
    done
    local end=$(date +%s)
    local cost=$(($end - $start))
    echo "脚本运行完成，共耗时：$cost 秒"

}

# main函数
function main()
{
    notify # 提示
    readConfig # 校验配置文件并获取全路径
    reads
    download    
}

main


