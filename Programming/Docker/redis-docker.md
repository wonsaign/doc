### redis-docker

#### 坑点
* docker使用redis.conf配置文件方式启动redis无反应无日志 
> https://www.cnblogs.com/wuxun1997/p/11804089.html 简单来讲不能设置daemonize = yes,需要改为no