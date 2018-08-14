#!/bin/bash
dir_path="/path/"
files=$(ls $dir_path)

username='user'
password='password'
webdav_url="http://xxx/xxx/xxx"

datetime=$(date +%Y%m%d)

check_dir() {
    dir_url=$1
    response_code=$(curl --user $username:$password $dir_url -I -o /dev/null -s -w %{http_code})
    if [[ $response_code == '200' ]];then
        echo '0'
    elif [[ $response_code == '404' ]];then
        echo '1'
    else
        echo '2'
    fi
}


mkdir_dir() {
    dir_url=$1
    response=$(check_dir $dir_url)
    if [[ $response == '0' ]];then
        echo $dir_url '已存在！'
    elif [[ $response == '1' ]]; then
        [[ $(curl -X MKCOL --user $username:$password $dir_url -I -o /dev/null -s -w %{http_code}) == '201' ]] && echo $dir_url '创建成功！' || echo $dir_url '创建失败！'
    else
        echo $dir_url '创建失败！'
    fi
}

delete_dir() {
    dir_url=$1
    response=$(check_dir $dir_url)
    if [[ $response == '0' ]];then
        [[ $(curl -X DELETE --user $username:$password $dir_url -I -o /dev/null -s -w %{http_code}) == '201' ]] && echo $dir_url '删除成功！' || echo $dir_url '删除失败！'
    elif [[ $response == '1' ]]; then
        echo $dir_url '不存在'
    else
        echo $dir_url '删除失败！'
    fi 
}

post_file() {
    file_name=$1
    file_path=$2
    dir_url=$3
    file_url=${dir_url}${file_name}
    file_response=$(check_dir $file_url)
    if [[ $file_response == '0' ]];then
        echo $file_url '已存在！'
    elif [[ $file_response == '1' ]];then
        [[ $(curl -T $file_path --user $username:$password $dir_url -I -o /dev/null -s -w %{http_code}) == '201' ]] && echo $file_url '提交成功!' || echo $file_url '提交失败!'
    else
        echo $file_url '提交失败！'
    fi
}

main() {
    mkdir_dir ${webdav_url}/${datetime}/
    for file in $files;do
    {
        post_file $file ${dir_path}/${file} ${webdav_url}/${datetime}/
    } &
    done
    wait
}


main 
