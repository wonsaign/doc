Spring Boot
================
### Spring 
* Spring IOC
  没有Spring之前
  ![依赖](../../../Images/programming/java/spring/对象关系.png)
  如果依赖稍稍复杂
  ![复杂依赖](../../../Images/programming/java/spring/复杂的依赖关系.png)
  Spring容器存在后
  ![ioc](../../../Images/programming/java/spring/IOC容器.png)
* Spring 不同版本的特性（spring 4 @Condition）
  * 1.0 创建了ioc 和 aop （xml注入）
  * 2.X 增加了注解注入
  * 3.X 增加了profile mvc更好的支持
  * 4.X 全面支持jdk1.8，Restful添加，Condition
  * 5.X webflux 测试增强
### Spring+SpringMVC 与 SpringBoot
* SpringMVC dispatcherServlet
  * MVC核心`DispatcherServlet`
  ![disptacher](../../../Images/programming/java/spring/mvc_disptacher.png)
  * MVC配置图 
  ![webxml](../../../Images/programming/java/spring/mvc_webxml配置.png)
  ![mvcview](../../../Images/programming/java/spring/mvc_view配置.png)
* 基于Sring 4.0 条件配置（Conditional注解，只有是ConditionalOnMissingBean注解才可自定义实现）
  ![conditional](../../../Images/programming/java/spring/Conditional注解.png)
* SpringBoot 项目搭建
  * spring 网站 https://start.spring.io/
  * spring Spring Tools Suit
* Spring 配置方式 ：
  * yml/xml
  ![yml](../../../Images/programming/java/spring/boot_yml配置.png)
  * JavaConfig（使用@Configuration）
  ![javaconfig](../../../Images/programming/java/spring/javaconfig.png)
* SpringBoot其他的配置
  * springboot内置了300多个微调属性，同时可以使用度多种方式进行配置（等级由高到低）
    * 命令行：java -jar boot.jar --server.port:8080
    * java：comp/env
    * JVM系统属性
    * 操作系统环境变量System.getProperties()
    * 随机生成的带random.*前缀的属性
    * 应用程序以`外`application.yml  /  application.properties
    * 应用程序以`内`application.yml  /  application.properties
    * @PropertySource 标注的属性
    * 默认属性
  * 日志配置
    * 在resources里放入名字为：logback.xml的文件
    * 直接使用yml添加日志
    * 可以配置其他名字的日志，在yml文件中
  * @ConfigurationProperties，读取application.properties / yml文件中的配置
  * @Profile注解，配置多套配置文件
### SpringBoot启动原理
* SpringBoot 启动原理
* @SpringBootApplication是一个复合注解
  * @SpringBootConfiguration->其实就是@Configuration
  * @EnableAutoConfiguration：->@Import(AutoConfigurationImportSelector.class)`它借助@Import的帮助，将所有符合自动配置条件的bean定义加载到IoC容器`,AutoConfigurationImportSelector.class的作用就是读取配置spring-boot-autoconfiguration中的spring.factories文件
  ![autoconfig](../../../Images/programming/java/spring/autoconfigurationdefault.png)
    * @AutoConfigurationPackage->@Import(AutoConfigurationPackages.Registrar.class)作用是：返回了当前主程序类的同级以及子级的包组件。
  * @ComponentScan:它的功能其实就是自动扫描并加载符合条件的组件
* 下面是原理图
 ![autoconfig](../../../Images/programming/java/spring/boot原理图.png)

