### 没用过可以，但是你得了解

##### 分布式架构的原理
* 基本类型
  * 索引对应着mysql的表 index-table
  * type，类似于mysql表中的业务字段，比如order表中的type，1=实物，2虚拟，3其他等等。
  * index+type，其实共同确定了一个mysql中table的概念。
  * 每个type，有一个mapping，类似type的表结构定义。
  * document，代表mysql中的一行数据。
  * filed是每个字段的值。
* 一个索引分为多个shard，每个分布式机器分片，类似hashmap分片存储思想，每个分片多机备份。注`副本和主机不在同一个分布式机器内`。  
* es里，写只能primary shard，读可以是primary/replica shard，与kafka不同，kafka只能是leader节点负责读写。


##### ES读写数据
* 读数据
* 写数据