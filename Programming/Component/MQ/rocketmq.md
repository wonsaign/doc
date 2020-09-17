## RocketMQ 
#### 应用场景
* 订单 - 短信/积分/进销存服务
* 特点就是,并非强耦合的核心逻辑,将串行化的时间,改为并行化.

#### 基本组建
* NameServer -> Zookeeper ,注册中心的角色, 配置的是`全量信息`,就是全部的Broker信息.
* Broker(可以设置Topic) 提供MQ服务的角色,所以信息都会注册到NameServer
* Producer
* Cunsumer
* 简单的基本工作过程
  0. 准备工作,NameServer启动(注册中心),Broker启动,并加入注册中心,告知可以提供服务.
  1. **生产者**去NameServer中获取可用的Broker(或Topic),这步有点类似`域名解析`
  2. 找到对应的Broker, Send Message 发送消息
  3. **消费者**去NameServer中获取可用的Broker(或Topic),这步有点类似`域名解析`
  4. 找到对应的Broker, Receive Message 接受消息

#### 启动与配置
* 配置
  * 单机 broker.conf
    1. brokerClusterName=DefaultCluster #集群名称，可自定义
    2. brokerName=broker‐a  #Broker名称，可自定义
    3. brokerId=0 #如果是集群模式 id==0的时候是master ,id!=0都是slave
    4. namesrvAddr=localhost:9876 #定义服务地址，主存地址
    5. deleteWhen=04 #删除策略中,几点删除
    6. fileReservedTime=48 #删除策略中,最多暴露的小时数
    7. brokerRole=ASYNC_MASTER #有三个值:SYNC_MASTER，ASYNC_MASTER，SLAVE;同步和异步表示Master和Slave之间 同步数据的机制;
    8. flushDiskType=ASYNC_FLUSH #刷盘策略,ASYNC_FLUSH，SYNC_FLUSH表示同步刷盘和异步刷盘;SYNC_FLUSH
息写入磁盘后才返回成功状态，ASYNC_FLUSH不需要;
    9. autoCreateTopicEnable=true #自动开启Topic主题
    10. storePathRootDir=/data/rocketmq/store #消息存储根路径
    11. storePathCommitLog=/data/rocketmq/store/commitlog #日志路径
  * 集群broker-m.conf
    1. brokerClusterName=DefaultCluster #集群名称，可自定义
    2. brokerName=broker‐a  #Broker名称，可自定义
    3. brokerId=0 #如果是集群模式 id==0的时候是master ,id!=0都是slave
    4. namesrvAddr=192.168.1.1:9876;192.168.1.2:9876 #假设ip是这个, 指定slave节点ip ,rocketmq‐name服务地址,多个地址用;分开，不配置默认为localhost:9876
    5. deleteWhen=04 #删除策略中,几点删除
    6. fileReservedTime=48 #删除策略中,最多暴露的小时数
    7. brokerRole=ASYNC_MASTER #broker角色,同步master
    8. flushDiskType=ASYNC_FLUSH #刷盘策略,同步刷盘
    9. autoCreateTopicEnable=true #自动开启Topic主题
    10. listenPort=10911 #broker通信端口，默认端口
    11. storePathRootDir=/root/rocketmq/store‐m #日志路径
  * 集群broker-s.conf
    1. brokerClusterName=DefaultCluster #集群名称，可自定义
    2. brokerName=broker‐a  #Broker名称，可自定义
    3. brokerId=0 #如果是集群模式 id==0的时候是master ,id!=0都是slave
    4. namesrvAddr=192.168.1.1:9876;192.168.1.2:9876 #假设ip是这个, 指定slave节点ip ,rocketmq‐name服务地址,多个地址用;分开，不配置默认为localhost:9876
    5. deleteWhen=04 #删除策略中,几点删除
    6. fileReservedTime=48 #删除策略中,最多暴露的小时数
    7. brokerRole=ASYNC_MASTER #broker角色,同步master
    8. flushDiskType=ASYNC_FLUSH #刷盘策略,同步刷盘
    9. autoCreateTopicEnable=true #自动开启Topic主题
    10. listenPort=10911 #broker通信端口，默认端口
    11. storePathRootDir=/root/rocketmq/store‐s #日志路径
* 启动
  * 启动runbroker.sh脚本时候,若机器内存不够,可修改默认启动参数
  * 启动NameServer nohup sh bin/mqnamesrv ‐n localhost:9876 &
  * 启动Broker
    * nohup sh bin/mqbroker ‐n localhost:9876 autoCreateTopicEnable=true & # 不指定配置文件
    * nohup sh bin/mqbroker ‐n localhost:9876 ‐c conf/broker.conf autoCreateTopicEnable=true & #指定配置文件

#### 详解
* Broker
  * 一个broker对应一个topic
  * 默认一个topic创建4个queue(queue-0,queue-1,queue-2,queue-3)
  * 一个queue对应一个持久化文件
* 消费方式
  * 消费者,会根据topic,计算出对应的queue,并从中消费数据.
  * pull拉取消费,consume主动拉取消息,适合少量数据不会堆积过多
  * push推送消费,监听broker里的消息,一旦有消息,就推送给consume,深度的封装.
* **RocketMq可是像写SQL一样的过滤数据**. 通过设置参数enablePropertyFilter=true
  * 设计理念,过滤,减少太多的消息,导致网络拥堵,所以增加过滤条件,用CPU资源过滤,将所有数据进行搜索过滤
    * 问题点:每次都要过滤那么多的数据,CPU很忙
    * 解决点:使用布隆过滤器作为一个缓存.
* 延迟消费
  * 会创建一个SCHEDULE_TOPIC_XXX的中间队列,做中转,后台开启一个定时线程,检测到期的key,放入真正的topic中,消费者才能消费

#### 实现原来
> 大量的使用线程池,定时任务等,AQS的各种同步队列

