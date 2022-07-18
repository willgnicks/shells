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
arr=()

# 分割线
function splitline()
{
    s=$(printf "%-80s" "$1")
    echo "${s// /$1}"
}

# 提示信息
function notify()
{
    splitline "*"
    echo "## git 多项目下载脚本 ##"
    echo "## 该脚本仅适用于同步主库代码和关联fork库代码 ##"
    printf "使用说明：\n1、已经配置好本地电脑和fork库互信，已经有fork主库项目；\n"
    echo "2、记录主库SSH地址的配置文件与脚本同级目录，单个项目地址逐条存放；"
    echo "3、默认库为fork库，主库为同步代码使用；"
    echo "4、默认库别名fork，主库别名origin。"
    echo "*注*：脚本仅支持单分支的代码下载"
}

# 校验配置文件
function readConfig()
{
    splitline "*"
    read -p "请输入仓库配置文件名称 ：" config
    cd ..
    fullpath=$(pwd)"/$config"
    if test -z $config;then
        echo "输入内容为空，请重新输入！"
        readConfig
    fi
    if [ ! -e $fullpath ]
    then
        echo "文件不存在，请核对路径及文件名。程序退出！"
        splitline "*"
        exit
    fi
    
    if test ! -s $fullpath;then
        echo "此文件为空文件，请核对文件是否正确，程序退出！"
        splitline "*"
        exit
    fi
    echo "配置文件校验完成，请按照提示继续输入所需信息！"
    
}

# 重复循环录入某信息，直至不为空，可设置正则来匹配
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
    splitline "*"
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
    splitline "x"
    echo "${pro}项目添加fork库仓库地址及修改配置文件程序开始"
    
    # 进入项目目录，添加fork库的remote信息
    cd $pro
    $(git remote add fork ${head}${account}/${pro}${tail})
    
    # 推送当前分支去fork库
    $(git push -v fork $branch)
    
    # 进入git的默认库配置目录 修改配置文件中的默认库为fork
    cd .git
    $(sed -i.bak "s/remote = origin/remote = fork/" config)
    
    # 退出至工作目录
    cd ../..
    echo "${pro}项目添加fork库仓库地址及修改配置文件程序结束"
    splitline "x"
}

function scans()
{
    # 将当前目录下的文件进行扫描，判断目录下的文件是否有重复项目名的
    # 如果有重复的则进行剔除
    # 将剩余的项目的行号进行存储，存入arr全局数组
    # 随后将数组中的行号进行遍历下载
    splitline "*"
    splitline
    printf "配置文件全路径：$fullpath;\n指定分支名：$branch;\n指定识别账户：$account;\n"
    splitline "="
    echo "** 开始扫描当前文件夹  **"
    local content=$(sed '/^$/d' $fullpath | grep -v "#"  )
    local count=$(sed '/^$/d' $fullpath | grep -v "#" | awk 'END{print NR}' )
    local present=$(pwd)
    local counter=0
    for((i=1;i<=count;i++));
    do
        local msg="| 扫描进度 $i / $count \t | "
        local content=$(sed -n ${i}p $fullpath | grep -v "#")
        if [ -z "$content" ];then
            continue
        fi
        local prj=$(echo $content | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')
        if [ -e "$present/$prj" ]
        then
            printf "$msg ${prj} 项目已存在，无法再次下载\n"
            continue
        fi
        arr[$counter]=$i
        counter=$(($counter + 1))
        printf "$msg ${prj} 项目具备下载条件\n"
    done
    echo "** 结束扫描当前文件夹  **"
}

# 下载函数
function download()
{
    # 读取arr数组中可下载文件的行号
    # 将可下载的文件均进行依次下载
    # 使用下标的方式进行遍历
    scans
    splitline "="
    local start=$(date +%s)
    local count=${#arr[@]}
    # 读取配置文件 拼接命令 下载主库
    for((i=0;i<$count;i++));
    do  
    {
        local index=${arr[$i]}
        local address=$(sed -n ${index}p $fullpath)
        local project=$(echo ${address} | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')
        echo "项目${project}下载开始｜ 状态：开始"
        splitline "x"
        # 下载
        # git clone --progress --branch
        local cmd="git clone --progress --branch ${branch} -v $address"
        echo "$cmd"
        $cmd
        if [ $? -eq 0 ]
        then
            echo "clone项目成功，clone结束"
            addRepo $project
        else
            echo "clone项目失败，请核对授权及地址"
            continue
        fi
        echo "项目${project}下载结束 ｜ 状态：完成"
        splitline "="
    } &
    done
    wait
    local end=$(date +%s)
    local cost=$(($end - $start))
    echo "脚本运行完成，共耗时：$cost 秒"
    splitline "="
}

# main函数
function main()
{
    notify # 提示
    readConfig # 校验配置文件并获取全路径
    # scans # 扫描全路径下内容
    reads # 读取账号和项目名
    download # 下载可以下载的项目
}

main
