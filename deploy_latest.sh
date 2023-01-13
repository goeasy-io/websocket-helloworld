#!/bin/bash
# 开启错误退出
set -e

if ([ "$1" ])
then
    versionDir=$1
    echo "$versionDir"
else
  echo "required version dir"
  exit 1
fi

git_hub_usernamne=$2
git_hub_token=$3

git config --global user.email "${git_hub_usernamne}"
git config --global user.name "${git_hub_usernamne}"
git config --global user.password "${git_hub_token}"

# 推送至show-helloworld
if [ -d "show-helloworld" ]; then
    rm -rf show-helloworld
fi
echo "https://user:$git_hub_token@ghproxy.com/https://github.com/goeasy-io/show-helloworld.git"
git clone https://user:$git_hub_token@ghproxy.com/https://github.com/goeasy-io/show-helloworld.git show-helloworld
cd show-helloworld
# 传入的versionDir不存在退出执行
if [ -d $versionDir ]
then
  echo "exist"
else
  echo "version dir not exists"
  exit 1
fi
# 清除老数据
if [ -d "index.html" ]; then
    rm -rf index.html
fi
# 拷贝versionDir下的index.html到根目录index.html
cp $versionDir/index.html index.html
# 标记推送
git add .
git commit -m "[deploy.sh]将[$versionDir]版本部署到pages"
git push -u origin main
# 退出当前目录
cd ../
# 清理本地目录
rm -rf show-helloworld
