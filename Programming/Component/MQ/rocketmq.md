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

#### 消息队列的优点
* 优点
  * 削峰
  * 异步
  * 解耦
* 缺点
  * 系统可用性降低，如果mq故障了，就裂开了。
  * 复杂性更高了，
    * 重复发送，重复消费。一致性消费
    * 消息丢了 
    * 顺序乱了
    * mq积压
#### MQ的高可用
* rabbitmq
  * 使用镜像集群（单一集群，数据节点只会保存在一台机器上，其他机器只是通信作用，所以数据节点挂了，就没了），镜像集群，就像mysql的主从同步，保证了数据的可用性。`但是因为不是分布式的，所以数据量就非常大，积压问题`。
* kafka 
  * 本身是分布式存储，类似分段式存贮。但是如果3台机器，有一台挂机了，就会导致数据确实，kafka在后来增加了，每个机器的主从备份，保证了mq机器的可用性。只能从Leader消费和生产，Leader负责同步数据到follwer。
* rocketmq
  * 刷盘策略/同步策略
  * 生产者端可以做主从集群。
#### MQ的一致性
> 要有消费标志符
* kafka
  * 每条消息有offset，代表了消息的序号，消费者不是立马提交offset，而是定时定期提交批量提交一次offset，所以如果消费者重启，可能会产生重复消费。
* 保证幂等性
  * 先用guava（考虑分布式同步问题，可以直接使用redis，定时记录），创建一个10分钟缓存的内存set，第一层拦截
  * 第二数据库，唯一建保证幂等
#### MQ消息丢失
> 从生产者，消费者，mq保障
* rabbitmq（rocktemq与之类似，思路是一样的。）
  * 生产者生产完消息，网络传输丢了
    * 支持事务，channel.txSelect...channel.txRollback... channel.txCommit,同步方式，吞吐量降低。
    * channel设置成confirm模式，异步，好像rocketmq也是这样的，有一个中间状态的队列。
  * 消费者rabbitmq内部出错，没能保存下来
    * 持久化到磁盘上
  * mq挂了，存在mq中的内存丢失了,这种情况是打开autoAck，提示mq我已经消费，但实际上并没有被消费掉
    * autoAck关闭，自己手动返回ack消息。
    * rocktemq去pull消息，根据offset标记已经成功消费的下标。
* kafka
  * mq自动offset确认关闭。手动提交
  * replication.factor参数必须大于1，每个partition必须有两个副本
  * min.insync.replicas参数，必须大于1，leader至少感知到有一个follower在于自己通信。
  * producer端设置acks=all，每条消息必须写入raplica后，才认为写入成功。reties=MAX，无限写入，直到成功。
#### MQ消息顺序保障
> 思路，保证一个消费者只消费队列
* rabbitmq
  * queue里有3条消息，三个消费者，消费的速度顺序不同，消息的顺序就乱了
    * 保证顺序的queue，一定要只有一个消费者消费，其他两个消费者可以消费另外一个队列。
* kafka
  * kafka的partion本身的消息是有顺序的，但是如果消费者使用多线程，那么也有可能产生消费错乱。
    * 使用内存队列queue，然后按照唯一建（orderNo）放入内存queue，每个线程消费一个对应的queue，这样就保证了顺序性。
#### MQ消息积压
* 消费者挂了，很多消息积压了
  * kafka
    * 先恢复原来的消费者
    * 临时创建程序，将原来3个partion写入一个新的有30个partion的消息对列后，临时增加机器，消费30个partion，10倍消费。
  * rabbitmq设置了过期时间
    * 线上禁止设置mq的过期时间
