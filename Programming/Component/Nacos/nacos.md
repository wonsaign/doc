### Nacos文档

#### nacos被坑文档
1. 注册nacos时候，springcloud:localhost，观测一下服务在注册中心的注册地址，不是，修改对应的ip
2. 注意spring.application要与dubbo.id相同，否则`group`参数会找到错误的
3. 当前服务器一旦启动微服务，比如192.168.1.170,那么这台机器上之前**所有**在nacos注册中心存活的实例都会接受到心跳，从而认为存活。一定要通过telnet查看当前的服务有多少存活。确保是否启动了该服务。
4. 当一个服务中，配置两个以上的provider，好像有问题，需要研究一下。
5. 当服务b启动的时候，依赖服务a，a死掉了，访问不到，正常，但是a成功启动后，还是无法访问，需要重启b服务（巨坑）
6. 当找不到服务的时候
   1. 是否是dubbo发现的包位置
   2. 是否install
   3. 服务提供者是否有`@DubboService(protocol = "dubbo")`,`@Component`两个注解
7. dubbo 服务提供者，就算使用异步调用方式，如果在规定的时间内未完成，还是会进行retries，导致初始化数据的接口，会进行多次的retries，导致刷了3遍（retries默认是2）。
