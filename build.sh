#!/bin/bash
# 开启错误退出
set -e

if [ "$1" ]; then
    ACTION=$1
fi

config_appkey=$2
git_email=$3
git_usernamne=$4
git_password=$5
git_hub_usernamne=$6
git_hub_token=$7
echo "action: $ACTION"
echo "config_appkey: $config_appkey"
echo "git_email: $git_email"
echo "git_usernamne: $git_usernamne"
echo "git_password: $git_password"
echo "git_hub_usernamne: $git_hub_usernamne"
echo "git_hub_token: $git_hub_token"

# 获取当前版本并创建目录
confirm_version() {
    echo "----------start execute confirm_version----------"
    originBranch=$(git rev-parse --abbrev-ref HEAD)

    if [ "$ACTION" = "r" ]; then
        # release 版本
        cd web-vue3
        currentVersion=$(npm version patch --no-git-tag-version)
        vesionDir=${currentVersion:1}
        git add .

        cd ../uniapp-vue
        npm version patch --no-git-tag-version
        node correctManifestVersion.js
        git add .

        git commit -m "[CI-build.sh]版本号修改为：$currentVersion, 准备生成release的tag"
        git push origin $originBranch
        # 打tag，推送并切分支
        git tag $currentVersion
        git push origin $currentVersion
        git checkout $currentVersion

    elif [ "$ACTION" = "b" ]; then
        # build 版本
        cd web-vue3
        currentVersion=$(npm run env | grep npm_package_version | cut -d '=' -f 2)
        vesionDir=$currentVersion
    else
        # 本地开发 版本
        cd web-vue3
        currentVersion=$(npm run env | grep npm_package_version | cut -d '=' -f 2)
        vesionDir="show-helloworld/"$currentVersion
    fi
    # 退回根目录
    cd ../
    echo "version confirmed:$currentVersion"
    echo "----------end execute confirm_version----------"
}

# 获取当前版本并创建目录
make_build_folder() {
    echo "----------start execute make_build_folder----------"
    # 创建版本目录
    if [ -d "build" ]; then
        rm -rf build
    fi
    mkdir -p build/$vesionDir

    echo "made dir: build/$vesionDir"
    echo "----------end execute make_build_folder----------"
}
# 构建web服务
build_web() {
    echo "----------start execute build_web----------"
    cd web-vue3
    npm install
    npm run build --appkey=$config_appkey
    mv dist ../build/$vesionDir/web
    cd ../
    echo "----------end execute build_web----------"
}

# 构建custiner服务
build_uniapp() {
    echo "----------start execute build_uniapp----------"
    cd uniapp-vue
    npm install
    npm run build -- --appkey=$config_appkey
    mv dist/build/h5 ../build/$vesionDir/uniapp
    rm -rf dist
    cd ../
    echo "----------end execute build_uniapp----------"
}

# 拷贝index.html
copy_html() {
    echo "----------start execute copy_html----------"
    cp index.html build/$vesionDir/index.html
    # 替换index.html中的路径
    basePath="\/show-helloworld\/$vesionDir"
    uniappPath=src\=$basePath\\/uniapp\\/
    webPath=src\=$basePath\\/web\\/
    sed -i "s/src\=\"uniapp\/\"/$uniappPath/g" build/$vesionDir/index.html
    sed -i "s/src\=\"web\/\"/$webPath/g" build/$vesionDir/index.html
    echo "----------end execute copy_html----------"
}

# 升级web服务的版本
upgrade_versions() {
    echo "----------start execute upgrade_versions----------"
    if [ "$ACTION" = "r" ]; then
        git checkout -f $originBranch
    fi
    cd web-vue3
    nextVersion=$(npm version prerelease --no-git-tag-version)
    git add .
    cd ../uniapp-vue
    nextVersion=$(npm version prerelease --no-git-tag-version)
    node correctManifestVersion.js
    git add .
    # 设置信息
    git config user.name "${git_usernamne}"
    git config user.password "${git_password}"
    git config user.email "${git_email}"
    # 推送
    git commit -m "[CI-build.sh] 将版本号升级为：$nextVersion，为下个版本做准备"
    git push -u origin $originBranch

    echo "$currentVersion is build, next version $nextVersion"
    echo "----------end execute upgrade_versions----------"
}

# 推送至打包后文件夹到page项目
deploy() {
    echo "----------start execute deploy----------"
    ls
    echo "----------AAAAAAAAAAAAA----------"
    if [ -d "show-helloworld" ]; then
      rm -rf show-helloworld
    fi
     echo "----------https://oauth2:$git_hub_token@github.com/goeasy-io/show-helloworld.git----------"
    git clone https://oauth2:$git_hub_token@github.com/goeasy-io/show-helloworld.git show-helloworld
    du -sh *
    ls
    echo "----------fffff----------"
    cd show-helloworld
    ls
    cd ../
    echo "----------gggg----------"
    # 清除老数据
#    if [ -d "show-helloworld/$versionDir" ]; then
#        rm -rf show-helloworld/$versionDir
#    fi
    echo "----------BBBBBBBBBBB----------"
    ls
    echo "----------CCCCCCCCCCCC----------"
    # 移动版本目录
    mv build/$versionDir show-helloworld/
    echo "----------DDDDDDDDDDDDD----------"
    ls
    echo "----------EEEEEEEEEEEEE----------"
    # 切换仓库
    cd show-helloworld
    echo "----------FFFFFFFFFFFFF----------"
    ls
    echo "----------GGGGGGGGGGGGG----------"
    # 标记推送
    git add $versionDir
    git commit -m "[CD-build.sh]将$versionDir部署到pages"

#    git config --global user.email "${git_hub_usernamne}"
#    git config --global user.name "${git_hub_usernamne}"
#    git config --global user.password "${git_hub_token}"

    git push -u origin main
    # 退出当前目录
    cd ../
    echo "----------end execute deploy----------"
}

# 清理本地目录
clear_file() {
    echo "----------start execute clear_file----------"
    rm -rf show-helloworld
    rm -rf build
    rm -rf uniapp-vue/node_modules
    rm -rf web-vue3/node_modules
    echo "----------end execute clear_file----------"
}

confirm_version
make_build_folder
#build_web
#build_uniapp
copy_html
if [ "$ACTION" != "" ]; then
    deploy
    clear_file
    upgrade_versions
else
    # 启动静态页面服务
    cd build
    http-server .
fi
