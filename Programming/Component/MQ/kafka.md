# Kafka
[TOC]

### 背景
> Kafka 是一个消息系统，原本开发自 LinkedIn，用作 LinkedIn 的活动流（Activity Stream）和运营数据处理管道（Pipeline）的基础。现在它已被多家不同类型的公司 作为多种类型的数据管道和消息系统使用。
### 简介
> Kafka 是一种分布式的，基于发布 / 订阅的消息系统。
主要设计目标如下：
1. 以时间复杂度为 O(1) 的方式提供消息持久化能力，即使对 TB 级以上数据也能保证常数时间复杂度的访问性能。
2. 高吞吐率。即使在非常廉价的商用机器上也能做到单机支持每秒 100K 条以上消息的传输。
3. 支持 Kafka Server 间的消息分区，及分布式消费，同时保证每个 Partition 内的消息顺序传输。
4. 同时支持离线数据处理和实时数据处理。
5. Scale out：支持在线水平扩展。
### 主要概念

-------
#### 生产者和消费者
> 单生产者和消费者，暂且不表
1. 消费者组,可以消费一个topic内不同的partition
#### Topic（主题）和Partition（分区）
***Topic***，可以类比于存贮数据库中的表，或者存贮文件的目录。
***Partition***：每个`Topic`可以有很多的Partition分区,每个分区是一个顺序存贮的方式
#### Broker（经纪人）
一个kafka服务器就叫broker

### 设计与实现
#### 讨论一：Kafka 存储在文件系统上

Kafka 的消息是存在于文件系统之上的。Kafka 高度依赖文件系统来存储和缓存消息，一般的人认为 “磁盘是缓慢的”，所以对这样的设计持有怀疑态度。

        现代的操作系统针对磁盘的读写已经做了一些优化方案来加快磁盘的访问速度。比如，预读
    会提前将一个比较大的磁盘快读入内存。后写会将很多小的逻辑写操作合并起来组合成一个
    大的物理写操作。并且，操作系统还会将主内存剩余的所有空闲内存空间都用作磁盘缓存，
    所有的磁盘读写操作都会经过统一的磁盘缓存（除了直接 I/O 会绕过磁盘缓存）。综合这
    几点优化特点，如果是针对磁盘的顺序访问，某些情况下它可能比随机的内存访问都要快，
    甚至可以和网络的速度相差无几。

上述的 Topic 其实是逻辑上的概念，面相消费者和生产者，物理上存储的其实是 Partition，每一个 Partition 最终对应一个目录，里面存储所有的消息和索引文件。
默认情况下，每一个 Topic 在创建时如果不指定 Partition 数量时只会创建 1 个 Partition。比如，我创建了一个 Topic 名字为 test ，没有指定 Partition 的数量，那么会默认创建一个 test-0 的文件夹，这里的命名规则是：<topic_name>-<partition_id>。

-------

任何发布到 Partition 的消息都会被追加到 Partition 数据文件的尾部，这样的顺序写磁盘操作让 Kafka 的效率非常高（经验证，顺序写磁盘效率比随机写内存还要高，这是 Kafka 高吞吐率的一个很重要的保证）。

每一条消息被发送到 Broker 中，会根据 Partition 规则选择被存储到哪一个 Partition。如果 Partition 规则设置的合理，所有消息可以均匀分布到不同的 Partition中。

#### 讨论二：Kafka 中的底层存储设计
假设我们现在 Kafka 集群只有一个 Broker，我们创建 2 个 Topic 名称分别为：「topic1」和「topic2」，Partition 数量分别为 1、2，那么我们的根目录下就会创建如下三个文件夹：
```
|--topic1-0
|--topic2-0,--topic2-1
```

在 Kafka 的文件存储中，同一个 Topic 下有多个不同的 Partition，每个 Partition 都为一个目录，而每一个目录又被平均分配成多个大小相等的 Segment File 中，Segment File 又由 index file 和 data file 组成，他们总是成对出现，后缀 “**.index**” 和 “**.log**” 分表表示 Segment 索引文件和数据文件。

**Segment 是 Kafka 文件存储的最小单位。** Segment 文件命名规则：Partition 全局的第一个 Segment 从 0 开始，后续每个 Segment 文件名为上一个 Segment 文件最后一条消息的 offset 值。数值最大为 64 位 long 大小，19 位数字字符长度，没有数字用0填充。如 00000000000000368769.index 和 00000000000000368769.log。

#### 讨论二：Kafka 如何保证可靠性
1. 一致性：同一个分区，消息是有序的，
    ```
    push A,B,C
    ---
    pull A,B,C
    ```
2. 原子性：所有record写入in-sync状态，消息才会commit。
3. 持久性：一旦消息已提交，那么只要有一个副本存活，数据不会丢失，消费者只能读取到已提交的消息。
4. 隔离性：每个消费族都有自己的offset

### 技术注意点
1. 每个Partition内的消息是顺序的，如果一个topic只有一个partition是可以保证顺序的，但是如果有多个，无法在全局保证顺序性
2. Partition内的Record是无法被删除的，消息有过期时间，过期后自动删除，所以kafka可以被重复消费。
3. Partition会保存每个`Consumer Group`的offset。
4. kafka是pull模型，考虑不同消费者的机器性能不一样。
5. Kafka采用稀疏索引存贮 

![kafka](https://gitee.com/wonsaign/static-resource/raw/master/images/Kafka.png)

### Kafka配置项
1 spring 中 kafka参数
```
allow.auto.create.topics = true
auto.commit.interval.ms = 100
auto.offset.reset = earliest
bootstrap.servers = [127.0.0.1:9092]
check.crcs = true
client.dns.lookup = use_all_dns_ips
client.id = consumer-laowang-1
client.rack = 
connections.max.idle.ms = 540000
default.api.timeout.ms = 60000
enable.auto.commit = true
exclude.internal.topics = true
fetch.max.bytes = 52428800
fetch.max.wait.ms = 500
fetch.min.bytes = 1
group.id = laowang
group.instance.id = null
heartbeat.interval.ms = 3000
interceptor.classes = []
internal.leave.group.on.close = true
internal.throw.on.fetch.stable.offset.unsupported = false
isolation.level = read_uncommitted
key.deserializer = class com.zeusas.cloud.kafka.serialization.FastjsonDeserializer
max.partition.fetch.bytes = 1048576
max.poll.interval.ms = 300000
max.poll.records = 500
metadata.max.age.ms = 300000
metric.reporters = []
metrics.num.samples = 2
metrics.recording.level = INFO
metrics.sample.window.ms = 30000
partition.assignment.strategy = [class org.apache.kafka.clients.consumer.RangeAssignor]
receive.buffer.bytes = 65536
reconnect.backoff.max.ms = 1000
reconnect.backoff.ms = 50
request.timeout.ms = 30000
retry.backoff.ms = 100
sasl.client.callback.handler.class = null
sasl.jaas.config = null
sasl.kerberos.kinit.cmd = /usr/bin/kinit
sasl.kerberos.min.time.before.relogin = 60000
sasl.kerberos.service.name = null
sasl.kerberos.ticket.renew.jitter = 0.05
sasl.kerberos.ticket.renew.window.factor = 0.8
sasl.login.callback.handler.class = null
sasl.login.class = null
sasl.login.refresh.buffer.seconds = 300
sasl.login.refresh.min.period.seconds = 60
sasl.login.refresh.window.factor = 0.8
sasl.login.refresh.window.jitter = 0.05
sasl.mechanism = GSSAPI
security.protocol = PLAINTEXT
security.providers = null
send.buffer.bytes = 131072
session.timeout.ms = 15000
socket.connection.setup.timeout.max.ms = 127000
socket.connection.setup.timeout.ms = 10000
ssl.cipher.suites = null
ssl.enabled.protocols = [TLSv1.2]
ssl.endpoint.identification.algorithm = https
ssl.engine.factory.class = null
ssl.key.password = null
ssl.keymanager.algorithm = SunX509
ssl.keystore.certificate.chain = null
ssl.keystore.key = null
ssl.keystore.location = null
ssl.keystore.password = null
ssl.keystore.type = JKS
ssl.protocol = TLSv1.2
ssl.provider = null
ssl.secure.random.implementation = null
ssl.trustmanager.algorithm = PKIX
ssl.truststore.certificates = null
ssl.truststore.location = null
ssl.truststore.password = null
ssl.truststore.type = JKS
value.deserializer = class com.zeusas.cloud.kafka.serialization.FastjsonDeserializer
```

### Kafka命令
1. 查看所有的topic
```bash
docker:
1. 进入容器 cd /opt/kafka
2. bin/kafka-topics.sh --list --zookeeper zookeeper:2181 #这里的zookeeper:2181实际上是IP，在docker内可以用服务表示
```
2. 查看分区
```bash
bin/kafka-topics.sh --zookeeper zookeeper:2181 --describe --topic yourTopicName
```
3. 创建topic
```bash
创建一个名为test，三个副本，一个分区的Topic
bin/kafka-topics.sh --create --topic test --bootstrap-server localhost:9092
```
4. 发送消息
```bash
向名为test的topic发送内容
bin/kafka-console-producer.sh --topic test --bootstrap-server localhost:9092
```
5. 消费消息
```bash
bin/kafka-console-consumer.sh --topic test --from-beginning --bootstrap-server localhost:9092
```

### Spring-kafka
#### Producer
> 使用spring封装过的KafkaTemplate进行消息发送，默认发送是异步的，若要同步方式，template发送返回的是Future,通过get()方法同步

`KafkaTemplate`模版方法：
```java
// data：消息的数据
ListenableFuture<SendResult<K, V>> sendDefault(V data);

// key：消息的键
ListenableFuture<SendResult<K, V>> sendDefault(K key, V data);

ListenableFuture<SendResult<K, V>> sendDefault(Integer partition, K key, V data);

ListenableFuture<SendResult<K, V>> sendDefault(Integer partition, Long timestamp, K key, V data);

//topic：这里填写的是Topic的名字
ListenableFuture<SendResult<K, V>> send(String topic, V data);

ListenableFuture<SendResult<K, V>> send(String topic, K key, V data);

// partition 这里填写的是分区的id，其实也是就第几个分区，id从0开始。表示指定发送到该分区中
ListenableFuture<SendResult<K, V>> send(String topic, Integer partition, K key, V data);

// timestamp：时间戳，一般默认当前时间戳
ListenableFuture<SendResult<K, V>> send(String topic, Integer partition, Long timestamp, K key, V data);

// ProducerRecord：消息对应的封装类，包含<topic, partition, timestamp, key, data>
ListenableFuture<SendResult<K, V>> send(ProducerRecord<K, V> record);

// Message<?>：Spring自带的Message封装类，包含消息及消息头
ListenableFuture<SendResult<K, V>> send(Message<?> message);
```

-------

配置default,默认指定defaultTopic
```java
@Bean("defaultKafkaTemplate")
public KafkaTemplate<Integer, String> defaultKafkaTemplate() {
    KafkaTemplate template = new KafkaTemplate<Integer, String>(producerFactory());
    template.setDefaultTopic("topic.quick.default");
    return template;
}
```

-------

监听器，实现`ProducerListener`接口的处理器
```java
@Component
public class KafkaSendResultHandler implements ProducerListener {

    private static final Logger log = LoggerFactory.getLogger(KafkaSendResultHandler.class);

    @Override
    public void onSuccess(ProducerRecord producerRecord, RecordMetadata recordMetadata) {
        log.info("Message send success : " + producerRecord.toString());
    }

    @Override
    public void onError(ProducerRecord producerRecord, Exception exception) {
        log.info("Message send error : " + producerRecord.toString());
    }
}
```

#### 事务
配置Kafka事务管理器并使用@Transactional注解
```java
// 设置事物ID前缀，方便查看
@Bean
public ProducerFactory<Integer, String> producerFactory() {
    DefaultKafkaProducerFactory factory = new DefaultKafkaProducerFactory<>(senderProps());
    factory.transactionCapable();
    factory.setTransactionIdPrefix("tran-");
    return factory;
}
    
// 声明事物
@Bean
public KafkaTransactionManager transactionManager(ProducerFactory producerFactory) {
    KafkaTransactionManager manager = new KafkaTransactionManager(producerFactory);
    return manager;
}
```

-------

使用KafkaTemplate.executeInTransaction开启事务
```java
@Test
public void testExecuteInTransaction() throws InterruptedException {
    kafkaTemplate.executeInTransaction(new KafkaOperations.OperationsCallback() {
        @Override
        public Object doInOperations(KafkaOperations kafkaOperations) {
            kafkaOperations.send("topic.quick.tran", "test executeInTransaction");
            throw new RuntimeException("fail");
            //return true;
        }
    });
}
```

#### Consumer
> 使用@KafkaListener注解，进行监听消费，此种方式是Spring推荐的

使用`非注解`方式去监听Topic,自己创建`KafkaMessageListenerContainer`
```java
@Autowired
private Environment environment;

@Bean
public KafkaMessageListenerContainer demoListenerContainer() {
    return new KafkaMessageListenerContainer(consumerFactory(), demoListener());
}

private ContainerProperties demoListener(){
    ContainerProperties properties = new ContainerProperties("test");

    properties.setGroupId("laowangba");

    properties.setMessageListener(new MessageListener<String, Object>() {
        private Logger log = LoggerFactory.getLogger(this.getClass());
        @Override
        public void onMessage(ConsumerRecord<String, Object> record) {
            log.info("topic.quick.bean receive : " + record.toString());
        }
    });
    return properties;
}

@Bean
public ConsumerFactory<String, String> consumerFactory() {
    return new DefaultKafkaConsumerFactory<>(consumerConfigs());
}

private Map<String, Object> consumerConfigs() {
    Map<String, Object> props = new HashMap<>();
    props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, environment.getProperty("spring.kafka.bootstrap-servers"));
    props.put(ConsumerConfig.GROUP_ID_CONFIG, "laowangba");
    props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
    props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
    return props;
}
```

-------

@KafkaListener参数讲解
注解的详解
```java
public @interface KafkaListener {
    String id() default "";//消费者的id，当GroupId没有被配置的时候，默认id为GroupId

    String containerFactory() default "";//上面提到了@KafkaListener区分单数据还是多数据消费只需要配置一下注解的containerFactory属性就可以了，这里面配置的是监听容器工厂，也就是ConcurrentKafkaListenerContainerFactory，配置BeanName

    String[] topics() default {};//topics：需要监听的Topic，可监听多个

    String topicPattern() default ""; //可配置更加详细的监听信息，必须监听某个Topic中的指定分区，或者从offset为200的偏移量开始监听

    TopicPartition[] topicPartitions() default {};

    String containerGroup() default "";

    String errorHandler() default "";//监听异常处理器，配置BeanName

    String groupId() default "";// 消费组ID

    boolean idIsGroup() default true; // id是否为GroupId

    String clientIdPrefix() default ""; //消费者Id前缀

    String beanRef() default "__listener"; // 真实监听容器的BeanName，需要在 BeanName前加 "__"
}

```
-------
监听方法接受的参数
```java
// data ： 对于data值的类型其实并没有限定，根据KafkaTemplate所定义的类型来决定。data为List集合的则是用作批量消费。
public void listen1(String data) 
// ConsumerRecord：具体消费数据类，包含Headers信息、分区信息、时间戳等
public void listen2(ConsumerRecord<K,V> data) 
// Acknowledgment：用作Ack机制的接口
public void listen3(ConsumerRecord<K,V> data, Acknowledgment acknowledgment) 

public void listen4(ConsumerRecord<K,V> data, Acknowledgment acknowledgment, Consumer<K,V> consumer) 

public void listen5(List<String> data) 

public void listen6(List<ConsumerRecord<K,V>> data) 

public void listen7(List<ConsumerRecord<K,V>> data, Acknowledgment acknowledgment) 

// Consumer：消费者类，使用该类我们可以手动提交偏移量、控制消费速率等功能
public void listen8(List<ConsumerRecord<K,V>> data, Acknowledgment acknowledgment, Consumer<K,V> consumer)
```

-------
批量消费
```yml
spring:
  kafka:
    consumer:
      group-id: test-consumer-group
      bootstrap-servers: 118.190.152.59:9092
      max-poll-records: 5 # 一次 poll 最多返回的记录数
    listener:
      type: batch # 开启批量消费
```

-------
注解方式获取消息头及消息体
```java
@KafkaListener(id = "anno", topics = "topic.quick.anno")
public void annoListener(@Payload Student stu,
                         @Header(KafkaHeaders.RECEIVED_MESSAGE_KEY) Integer key,
                         @Header(KafkaHeaders.RECEIVED_PARTITION_ID) int partition,
                         @Header(KafkaHeaders.RECEIVED_TOPIC) String topic,
                         @Header(KafkaHeaders.RECEIVED_TIMESTAMP) long ts) {
    log.info("topic.quick.anno receive : \n"+
        "data : "+stu+"\n"+
        "key : "+key+"\n"+
        "partitionId : "+partition+"\n"+
        "topic : "+topic+"\n"+
        "timestamp : "+ts+"\n"
    );

}
```

-------
TODO：使用Ack机制确认消费
    1 设置ENABLE_AUTO_COMMIT_CONFIG=false，禁止自动提交
    2 设置AckMode=MANUAL_IMMEDIATE
    3 监听方法加入Acknowledgment ack 参数

-------
容器定时启动
```java
@Component
@EnableScheduling
public class TaskListener{

    private static final Logger log= LoggerFactory.getLogger(TaskListener.class);

    @Autowired
    private KafkaListenerEndpointRegistry registry;

    @Autowired
    private ConsumerFactory consumerFactory;

    @Bean
    public ConcurrentKafkaListenerContainerFactory delayContainerFactory() {
        ConcurrentKafkaListenerContainerFactory container = new ConcurrentKafkaListenerContainerFactory();
        container.setConsumerFactory(consumerFactory);
        //禁止自动启动
        container.setAutoStartup(false);
        return container;
    }

    @KafkaListener(id = "durable", topics = "topic.quick.durable",containerFactory = "delayContainerFactory")
    public void durableListener(String data) {
        //这里做数据持久化的操作
        log.info("topic.quick.durable receive : " + data);
    }


    //定时器，每天凌晨0点开启监听
    @Scheduled(cron = "0 0 0 * * ?")
    public void startListener() {
        log.info("开启监听");
        //判断监听容器是否启动，未启动则将其启动
        if (!registry.getListenerContainer("durable").isRunning()) {
            registry.getListenerContainer("durable").start();
        }
        registry.getListenerContainer("durable").resume();
    }

    //定时器，每天早上10点关闭监听
    @Scheduled(cron = "0 0 10 * * ?")
    public void shutDownListener() {
        log.info("关闭监听");
        registry.getListenerContainer("durable").pause();
    }



}
```

#### 序列化
> Kafka提供了很多序列化的方式，Byte，String，Integer，Json等等

`Provider` -> JsonSerializer
`Consumer` -> StringDeserializer
```java
// 通过StringJsonMessageConverter可通过@Payload Car car.还原为实体
@Bean
RecordMessageConverter messageConverter() {
    return new StringJsonMessageConverter();
}
```

#### 转发
```java
@Bean
public ConcurrentKafkaListenerContainerFactory<Integer, String> kafkaListenerContainerFactory() {
    ConcurrentKafkaListenerContainerFactory<Integer, String> factory = new ConcurrentKafkaListenerContainerFactory<>();
    factory.setConsumerFactory(consumerFactory());
    // 设置转发的template
    factory.setReplyTemplate(kafkaTemplate());
    return factory;
}
    
    
@Component
public class ForwardListener {

    private static final Logger log= LoggerFactory.getLogger(ForwardListener.class);

    @KafkaListener(id = "forward", topics = "topic.quick.target")
    @SendTo("topic.quick.real")
    public String forward(String data) {
        log.info("topic.quick.target  forward "+data+" to  topic.quick.real");
        return "topic.quick.target send msg : " + data;
    }
}
```

#### 异常处理
单消息消费异常处理器，队列消费过程中的异常都会被`errorHandler`处理
```java
@Component
public class ErrorListener {

    private static final Logger log= LoggerFactory.getLogger(ErrorListener.class);

    @KafkaListener(id = "err", topics = "topic.quick.error", errorHandler = "consumerAwareErrorHandler")
    public void errorListener(String data) {
        log.info("topic.quick.error  receive : " + data);
        throw new RuntimeException("fail");
    }
    // 单一消费的处理
    @Bean
    public ConsumerAwareListenerErrorHandler consumerAwareErrorHandler() {
        return new ConsumerAwareListenerErrorHandler() {

            @Override
            public Object handleError(Message<?> message, ListenerExecutionFailedException e, Consumer<?, ?> consumer) {
                log.info("consumerAwareErrorHandler receive : "+message.getPayload().toString());
                return null;
            }
        };
    }

}


// 批量消费的处理
@Bean
public ConsumerAwareListenerErrorHandler consumerAwareErrorHandler() {
    return new ConsumerAwareListenerErrorHandler() {

        @Override
        public Object handleError(Message<?> message, ListenerExecutionFailedException e, Consumer<?, ?> consumer) {
            log.info("consumerAwareErrorHandler receive : "+message.getPayload().toString());
            MessageHeaders headers = message.getHeaders();
            List<String> topics = headers.get(KafkaHeaders.RECEIVED_TOPIC, List.class);
            List<Integer> partitions = headers.get(KafkaHeaders.RECEIVED_PARTITION_ID, List.class);
            List<Long> offsets = headers.get(KafkaHeaders.OFFSET, List.class);
            Map<TopicPartition, Long> offsetsToReset = new HashMap<>();
      
            return null;
        }
    };
}
```

### Spring-kafka在容器内执行流程
> Spring整理kafka主要分为两步

第一步：通过后置处理器->扫描注解方法->加载到容器

第二部：通过Register找到@KafkaLinstenr注解的容器->每个容器启动一个线程，线程一直执行->每隔5秒进行一次监听消费->找到容器对应的Java的Method，通过反射invoke方法，进行方法调用。
![spring-kafka流程图](http://tva1.sinaimg.cn/large/006jbqSUly1guje2a6ki7j62x962p4qp02.jpg)
