### Spring Cloud Alibaba 系列


#### 碎片知识
1. dubbo和feign
   1. dubbo 
      1. 专一的，rpc调用。不需要绑定全家桶
      2. 需要注册中心，不需要服务之前强行绑定。我不管这个服务之前提供给谁，我需要，我就引入API
      3. 自带负载均衡，支持失败重试，白名单功能、结果缓存、同步和异步调用的功能。
      4. 带统计和动态调整
   2. feign 简略版的http 
      1. Eukeka +Ribbon 默认轮询的方式实现负载均衡
      2. Zipkin 链路监控，实现类似Dubbo 监控平台的功能
2. nacos支持AP和CP两种模式
   1. 切换方式
    ```
    第一种方式：
    curl -X PUT '$NACOS_SERVER:8848/nacos/v1/ns/operator/switches?entry=serverMode&value=CP'
    第二种方式：
    #false为永久实例，true表示临时实例开启，注册为临时实例
    spring.cloud.nacos.discovery.ephemeral=false
    ```
3. 官方对比
    由于 Dubbo Spring Cloud 构建在原生的 Spring Cloud 之上，其服务治理方面的能力可认为是 Spring Cloud Plus，
    不仅完全覆盖 Spring Cloud 原生特性[5]，而且提供更为稳定和成熟的实现，特性比对如下表所示：
    | 功能组件                                             | Spring Cloud                           | Dubbo Spring Cloud                                     |
    | ---------------------------------------------------- | -------------------------------------- | ------------------------------------------------------ |
    | 分布式配置（Distributed configuration）              | Git、Zookeeper、Consul、JDBC           | Spring Cloud 分布式配置 + Dubbo 配置中心[6]          |
    | 服务注册与发现（Service registration and discovery） | Eureka、Zookeeper、Consul              | Spring Cloud 原生注册中心[7] + Dubbo 原生注册中心[8] |
    | 负载均衡（Load balancing）                           | Ribbon（随机、轮询等算法）             | Dubbo 内建实现（随机、轮询等算法 + 权重等特性）        |
    | 服务熔断（Circuit Breakers）                         | Spring Cloud Hystrix                   | Spring Cloud Hystrix + Alibaba Sentinel[9] 等        |
    | 服务调用（Service-to-service calls）                 | Open Feign、`RestTemplate`             | Spring Cloud 服务调用 + Dubbo `@Reference`             |
    | 链路跟踪（Tracing）                                  | Spring Cloud Sleuth[10] + Zipkin[11] | Zipkin、opentracing 等                                 |
4. sentinel限流工具
   1. 有客服端要下载
   2. 使用方式
      1. 代码实现
       ```java
        List<FlowRule> rules = new ArrayList<FlowRule>();
        FlowRule rule = new FlowRule();
        rule.setResource(str);
        // set limit qps to 10
        rule.setCount(10);
        rule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        rule.setLimitApp("default");
        rules.add(rule);
        FlowRuleManager.loadRules(rules);
       ```
      2. 控制台配置配置
5. getaway 网关
   1. 看配置 lb代表了负载均衡
        ```yml
        spring: 
          cloud:
            gateway:
            routes:
            - id: user-center  # 唯一标识，通常使用服务id
                uri: lb://user-center  # 目标URL，lb代表从注册中心获取服务，lb是Load Balance的缩写
                predicates:
                # Predicate集合
                - Path=/zj/cloud/v1/user-center/**  # 匹配转发路径
                filters:
                # Filter集合
                - StripPrefix=4  # 从第几级开始转发
        ```
6. dubbo spring cloud alibaba，记得要用bootstrap.yml 否则会默认使用zookeeper。
   1. dubbo 2.7.X后使用不一样的心跳机制，包含了空闲检测，使用Netty的IdleStateHandler空闲检测，天然的心跳机制。[官方文档](https://dubbo.apache.org/zh/blog/2018/08/19/dubbo-%E7%8E%B0%E6%9C%89%E5%BF%83%E8%B7%B3%E6%96%B9%E6%A1%88%E6%80%BB%E7%BB%93%E4%BB%A5%E5%8F%8A%E6%94%B9%E8%BF%9B%E5%BB%BA%E8%AE%AE/)
7. nacos相关操作(服务和实例不同，一个服务可以有很多个实例)
   1. curl -X DELETE '127.0.0.1:8848/nacos/v1/ns/instance?serviceName=spring-cloud-alibaba-dubbo-provider&ip=192.168.7.170&port=20880' 删除实例
   2. curl -X DELETE '127.0.0.1:8848/nacos/v1/ns/service?serviceName=spring-cloud-alibaba-dubbo-provider' 删除服务
   3. curl -X GET '127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=spring-cloud-alibaba-dubbo-provider' 查询实例
8. nacos可以配置mysql作为存贮
   1. nacos2.0集群，端口号不能连续，连续就端口占用，崩溃的无语
9. Nacos重启后微服务项目启动时后端出现NacosException: failed to req API异常解决办法
   1.  删除data目录下的内容