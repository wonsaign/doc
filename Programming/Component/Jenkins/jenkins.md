### Jenkins

#### 安装
> https://www.jenkins.io/ 详细见管网
* 启动 systemctl start jenkins.service
```
若启动失败
whereis java
将路径写入cadidates变量里
vi /etc/init.d/jenkins 
```

#### 账号密码
admin
admin1234


#### Jenkins踩坑

* 执行脚本，发现没有jvm环境，要加上source /etc/profile

```
source /etc/profile
/opt/shell/ordm_run.sh > /tmp/ordm
```

* Springboot jar包启动
```
jenkins启动时候会将所有的进程全部kill，此句防止被kill
BUILD_ID=DONTKILLME
nohup java -jar "${runhome}/${newjarname}" > "${runhome}/catalina.out"  2>&1 &
```