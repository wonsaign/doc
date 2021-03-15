### 项目搭建

* git基于标签打包
> https://www.cnblogs.com/Dev0ps/p/9125232.html
* git用户创建
> https://www.cnblogs.com/xuewenlong/p/12914921.html
* openvpn 配置
> https://www.jianshu.com/p/92b4d36a1dc4
> https://www.jianshu.com/p/17a56994b74f
> /usr/sbin/openvpn --daemon --cd /etc/openvpn/client --config client.ovpn --log-append /var/log/openvpn.log

* post steps
```
Source files          dp-ordm-webapp/target/**/*.war
Remove prefix         dp-ordm-webapp/target
Remote directory      jenkins_build_jars
Exec command          yourshell
```

#### Jenkins配置

* maven配置 Global Tool Configuration->配置maven目录
* maven配置 Configure System->配置ssh密钥
* 配置全局凭据credential

#### 所需插件

* Git Parameter
* Build With Parameters
* Publish Over SSH
* Maven Integration
* Role-based Authorization Strategy