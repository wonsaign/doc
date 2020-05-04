#### Netty
> Netty基于NIO模型.


* Netty的Server端,有两个EventLoopGroup,一个master,一个worker,对应的NIO中的两个线程池,使用一主多从(或多主多从,**多主可以用来负载均衡**)的模型结构.(1主多从展示:1主Selector,8个从Selector),
  * 一个EventLoopGrou master = new EventLoopGrou(1);
  * 一个EventLoopGrou worker = new EventLoopGrou(8);
* Neety实现模型.(**图中红色部分标记出主从结构与NIO模型中,处理完事件之后,再次注册到自身的不同,也是主从连接的关键.**)
![经典BIO](../../Images/programming/java/netty模型.png)
* ByteBuff


IO模型地址:
[javaIO](javaIO.md)

##### Netty重要组件-Pipeline
* ChannelPipeline,在Netty的channel里,有一个双向链表的容器,而存入链表中的都是实现了`ChannelHander`的`Handler`
* ChannelHander,处理了入站,出站的逻辑(ChannelOutboundHandler,ChannelInboundHandler)
![ChannelHander](../../Images/programming/java/Netty中Channel.png)

##### Netty拆包粘包
* TCP发包的时候,可能会对字符串进行拆包,粘包.如下图
  * D2和D1完整发的时候是正常的,
  * D2和D1一起发的时候是粘包
  * D2的一半和D1+D2的另一半是拆包
  * D1的一半和D2+D1的另一半是拆包

![ChannelHander](../../Images/programming/java/netty粘包拆包.png)
* 结果方式
  1. 自己增加分隔符(在业务里)
  2. 继承MessageToByteEncoder抽象类

##### Netty心跳检测机制
* 在`TCP长连接`中,保持有效性.
* 创建IdleStateHandler()的Hander加入ChannelPipeline的Hander链表容器中就可以实现心跳机制.
*  