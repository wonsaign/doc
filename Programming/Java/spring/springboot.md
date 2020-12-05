Spring Boot
================

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


### SpringBoot源码解读
> 什么是SpringBoot? 简化配置的Spring
#### SpringBoot自动装配的过程
> Spring通过扫描META-INF文件夹下的spring.factories文件,自动扫描对应的组件.
> 通过在MAVEN项目的pom文件中添加相关依赖包,因为接口由Spring调用方提供，所以使用SPI机制，并将常用的配置类添加，需要什么功能组件，便由Maven导入即可

 ![autoconfig](../../../Images/programming/java/spring/SpringBoot注解加载流程.png)

> SpringBoot如何启动的(包含了上面的部分)

 ![autoconfig](../../../Images/programming/java/spring/SpringBoot启动.png) -