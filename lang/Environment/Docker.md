## Docker
> 相对于VM这种方式，容器更轻更快，减少了每个VM不必要的os系统文件。

Docker 与 VM 简单说明
* Docker共享宿主计算机的硬件，以及OS
* VM共享计算机的硬件，但是每个VM都有自己的操作系统

镜像与容器
> 以开发的角度来讲，镜像是class，容器是由class生成的实例

Docker简单命令
* docker container ls 显示容器
* docker container ls 显示全部容器
* docker image ls 显示镜像
* docker container run -it -p 80:80 镜像名 /bin/bash  [^1]
* ctrl PQ 退出容器（不会终止进程）
* docker container exce -it 容器id /bin/bash 连接容器
* docker container stop 容器id 停止容器
* docker container rm 容器id 删除容器
* docker container ps 显示正在运行的容器



[^1]: 解释一下 `-it`代表了进入容器 `-p`代表了端口号  镜像名是指的是运行的镜像名称  `/bin/bash` 指的是容器运行的进程（如果进入容器后，使用exit退出容器，那么/bin/bash进程也将退出，那么容器也不会存在，因为容器不运行任何进程则无法存在。）若要退出界面，使用 ctrl PQ退出容器。