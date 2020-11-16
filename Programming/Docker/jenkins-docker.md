### jenkins
#### 命令
* docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts 这句话是执行命令，并将jenkins插件等文件放在宿主机上，不担心容器丢失而消亡。

#### 插件
* Post build task 构筑项目后可以执行，可以写脚本语言。
* maven
* Publish Over SSH