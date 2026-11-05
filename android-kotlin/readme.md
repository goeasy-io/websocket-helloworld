#如何运行
1. 在GoEasyApp里填入正确的appkey，然后直接运行调试即可

#如何调试厂商离线推送
1. 修改模块app->build.gradle里的配置
   1. android->defaultConfig-下的applicationId，要和厂商推送配置的包名一致
   2. 打开自定义签名注释，并填入正确的信息，厂商推送配置的指纹来源于该证书
   3. 将自定义签名证书放在模块app的根目录下