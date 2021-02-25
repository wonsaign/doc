## Hadoop学习

### Hadoop常用命令
* hdsf命令  ./hdfs dfs -ls /
* 检查状态   ./hadoop checknative -a
* hadoop启动 sbin/start-all.sh 
* hadoop停止 sbin/stop-all.sh 
* hadoop配置文件 /etc/hadoops

### HDFS，hadoop文件系统的简称
> 大数据存贮，第一次使用需要格式化
* hdfs机制
  * 心跳 ：NameNode类似于zookeeper，注册中心的那种，监控DataNode的心跳状态。
  * 负载均衡
### NameNode和DataNode
* NameNode类似于zookkeeper，注册中心的那种，监控DataNode的心跳状态。


### Mapred，mapreduce
> 大数据分布式计算，分而治之
* 

### Yarn
> 大数据资源调度


### 过程
* hdfs 文件上传 mapreduce1 32m
* 小文件处理 Sequence Files mapreduce1 39m


### 问题以及解决方案
##### Hdfs不适合小文件，但是真的有很多小文件怎么办？
* HAR文件方案
  *  本质依赖yarn  位置：hdfs 2:15
* Sequence Files
  * 小文件处理