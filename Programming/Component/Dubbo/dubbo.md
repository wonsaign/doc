#### Dubbo
##### Dubbo源码解读
* 通知机制,当结点变更,使用观察模式,通知其他结点. 大致流程.
  * 
![dubbo部门源码解读](../../../Images/programming/component/dubbo/Dubbo源码-ReferenceConfig-get.png)


* 负载均衡策略
  * 权重随机
  * 轮播
  * 最少活跃数
  * 一致性Hash算法 1:15-1:21
    * 热点问题,当结点的hash运算后,过于紧密. (默认虚拟160个结点,随机指向其中的结点,打乱结点之间的hash运算过与近导致的热点数据)
    * 其中某个结点坏掉导致多个数据结点的数据全部打乱(取模运算就会出现这个问题)

##### Dubbo协议/序列化
* Dubbo 支持的RPC协议列表

| **名称**   | **实现描述**   | **连接描述**   | **适用场景**   | 
|:----|:----|:----|:----|
| **dubbo**   | 传输服务: mina, netty(默认), grizzy序列化: hessian2(默认), java, fastjson自定义报文   | 单个长连接NIO异步传输   | 1、常规RPC调用2、传输数据量小 3、提供者少于消费者   | 
| **rmi**   | 传输：java rmi 服务序列化：java原生二进制序列化   | 多个短连接BIO同步传输   | 1、常规RPC调用  2、与原RMI客户端集成  3、可传少量文件  4、不防火墙穿透   | 
| **hessian**   | 传输服务：servlet容器序列化：hessian二进制序列化   | 基于Http 协议传输，依懒servlet容器配置   | 1、提供者多于消费者  2、可传大字段和文件 | 
| **http**   | 传输服务：servlet容器序列化：java原生二进制序列化   | 依懒servlet容器配置   | 1、数据包大小混合   | 
| **thrift**   | 与thrift RPC 实现集成，并在其基础上修改了报文头   | 长连接、NIO异步传输   |    | 
* 序列化：

|    | 特点   | 
|:----|:----|
| fastjson   | 文本型：体积较大，性能慢、跨语言、可读性高   | 
| fst   | 二进制型：体积小、兼容JDK原生的序列化。要求JDK1.7支持。   | 
| hessian2   | 二进制型：跨语言、容错性高、体积小   | 
| java   | 二进制型：在JAVA原生的基础上可以写入Null   | 
| compactedjava   | 二进制型：与java类似，内容做了压缩   | 
| nativejava   | 二进制型：原生的JAVA序列化   | 
| kryo   | 二进制型：体积比hessian2还要小，但容错性没有hessian2好 

* Dubbo协议报文编码
  ![dubbo部门源码解读](../../../Images/programming/component/dubbo/dubbo-protocol.png)
  * **magic**：类似java字节码文件里的魔数，用来判断是不是dubbo协议的数据包。魔数是常量0xdabb,用于判断报文的开始。
  * **flag**：标志位, 一共8个地址位。低四位用来表示消息体数据用的序列化工具的类型（默认hessian）高四位中，第一位为1表示是request请求，第二位为1表示双向传输（即有返回response），第三位为1表示是心跳ping事件。
  * **status**：状态位, 设置请求响应状态，dubbo定义了一些响应的类型。具体类型见com.alibaba.dubbo.remoting.exchange.Response
  * **invoke id**：消息id, long类型。每一个请求的唯一识别id（由于采用异步通讯的方式，用来把请求request和返回的response对应上）
  * **body length**：消息体body长度, int类型，即记录Body Content有多少个字节。
![dubbo部门源码解读](../../../Images/programming/component/dubbo/dubbo-报文格式.png)