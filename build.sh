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
ftp_host=$8
ftp_username=$9
ftp_password=$10
ftp_compressed=$11
echo ${ACTION} ${APPKEY} ${GIT_EMAIL} ${GIT_USER} ${GIT_PASS} ${GIT_HUB_USER} ${GIT_HUB_TOKEN} ${FTP_HOST} ${FTP_USER} ${FTP_PASS} ${FTP_UPLOAD_COMPRESSED}
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
        versionDir=${currentVersion:1}
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
        versionDir=$currentVersion
    else
        # 本地开发 版本
        cd web-vue3
        currentVersion=$(npm run env | grep npm_package_version | cut -d '=' -f 2)
        versionDir="show-helloworld/"$currentVersion
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
    mkdir -p build/$versionDir

    echo "made dir: build/$versionDir"
    echo "----------end execute make_build_folder----------"
}
# 构建web服务
build_web() {
    echo "----------start execute build_web----------"
    cd web-vue3
    npm ci
    npm run build -- --$config_appkey
    mv dist ../build/$versionDir/web
    cd ../
    echo "----------end execute build_web----------"
}

# 构建custiner服务
build_uniapp() {
    echo "----------start execute build_uniapp----------"
    cd uniapp-vue
    npm ci
    npm run build $config_appkey
    mv dist/build/h5 ../build/$versionDir/uniapp
    rm -rf dist
    cd ../
    echo "----------end execute build_uniapp----------"
}

# 拷贝index.html
copy_html() {
    echo "----------start execute copy_html----------"
    cp index.html build/$versionDir/index.html
    # 替换index.html中的路径
    basePath="\/helloworld\/$versionDir"
    uniappPath=src\=$basePath\\/uniapp\\/
    webPath=src\=$basePath\\/web\\/
    sed -i "s/src\=\"uniapp\/\"/$uniappPath/g" build/$versionDir/index.html
    sed -i "s/src\=\"web\/\"/$webPath/g" build/$versionDir/index.html
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

# 提交压缩文件或非压缩文件到ftp服务器
publish_ftp_server() {
    npm ci
    if [ "$ftp_compressed" = true ] ; then
        echo "ftp upload compressed files"
        mkdir $versionDir
        cp -rf ./build/$versionDir/** ./$versionDir/
        mkdir dist
        tar -czvf ./dist/$versionDir.tar.gz ./$versionDir
        node ftp-upload.js $ftp_host $ftp_username $ftp_password
	      rm -rf dist
        rm -rf $versionDir
        rm -rf node_modules
    else
        echo 'ftp upload uncompressed files'
        mkdir dist
	      cp -rf ./build/$versionDir/ ./dist/
        node ftp-upload.js $ftp_host $ftp_username $ftp_password
        rm -rf dist
        rm -rf node_modules
    fi
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

#confirm_version
#make_build_folder
#build_web
#build_uniapp
#copy_html
#if [ "$ACTION" != "" ]; then
#    publish_ftp_server
#    clear_file
#    upgrade_versions
#else
#    # 启动静态页面服务
#    cd build
#    http-server .
#fi
