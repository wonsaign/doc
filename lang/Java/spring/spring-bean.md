## Spring-Bean 源码解读
> Spring-Bean的核心包就是factory，此笔记重点识记Factory
### **org.springframework.beans**中重要的接口

#### Aware    是命令模式么？
* 是一种CallBack接口声明，给Bean设置各种属性，Aware的子接口要求只有一个void方法，如BeanClassLoaderAware接口，只有setBeanClassLoader一个方法。
* Spring中提供一些Aware相关接口，像是BeanNameAware、ApplicationContextAware、ResourceLoaderAware、ServletContextAware等等，实现这些 Aware接口的Bean在被初始之后，可以取得一些相对应的资源，例如实作BeanFactoryAware的Bean在初始后，Spring容器将会注入BeanFactory的实例，而实作ApplicationContextAware的Bean，在Bean被初始后，将会被注入 ApplicationContext的实例等等。

#### PropertyEditorRegistry
* 对于已经注册的Bean，可以压入方法在其中，很重要的接口。
* PropertyEditor是java的包，允许用户通过外部的编辑改变JavaBean内部的值

#### BeanFactory
* 官方解释：是root接口，一个有权限使用spring容器，是一个bean容器的基础View，Bean Factory的实现，应该支持标准的生命周期接口。
* 下面是完整的初始化方法以及它们的顺序是：
  *  BeanNameAware's {@code setBeanName}
    * BeanClassLoaderAware's {@code setBeanClassLoader}
    * BeanFactoryAware's {@code setBeanFactory}
    * EnvironmentAware's {@code setEnvironment}
    * EmbeddedValueResolverAware's {@code setEmbeddedValueResolver}
    * ResourceLoaderAware's {@code setResourceLoader}
      * (only applicable when running in an application context)
    * ApplicationEventPublisherAware's {@code setApplicationEventPublisher}
      * (only applicable when running in an application context)
    * MessageSourceAware's {@code setMessageSource}
      * (only applicable when running in an application context)
    * ApplicationContextAware's {@code setApplicationContext}
      * (only applicable when running in an application context)
    * ServletContextAware's {@code setServletContext}
      * (only applicable when running in a web application context)
    * {@code postProcessBeforeInitialization} methods of BeanPostProcessors
    * InitializingBean's {@code afterPropertiesSet}
    * a custom init-method definition
    * {@code postProcessAfterInitialization} methods of BeanPostProcessors

#### FactoryBean 装饰者模式
* 这个接口的实现类是一个特殊的Bean，它被用作工厂使用暴露对象，而不是直接作为Bean实例暴露自己。
* 如果一个实现了该接口的Bean，不能被当做一个正常的Bean使用了，FactoryBean是以Bean的风格样式定义的，但是当作为Bean的引用（reference）时[^1]，总是由FactoryBean自己创建的。
* 该接口，大量使用在Spring框架中，例如AOP或者Jndi。
* 具有工厂生成对象能力,只能通过getObject生成特殊的Bean。

#### InitializingBean
* 接口，要求Bean中所有的属性值，在初始化时全部赋值，有二选一的方式：
  * 要么自定义init方法
  * 要么在XML中声明
* 接口中有一个方法，afterPropertySet(),就是在所有属性都设置Ok以后，调用这个方法。

#### BeanMetadataElement


#### config包下
* BeanDefine，一个bean定义，描述了有属性，构造参数值和更多继承类中信息的bean实例
* BeanDefineHolder，一个持有name和alias的持有者，可以作为占位符在一个内部类（inner）Bean中，有一种组件的意思
* BeanDefineVisitor，可以穿过BeanDefine，从而分离Bean的metadata数据。
* Scope，策略接口，在ConfigurableBeanFactory中，代表了持有一个Bean实例的目标Scope（范围），允许扩展通过自定义其他范围[^2],比如在ApplicationContext的实现类WebApplicationContext中，提供了request和session两种范围。
* ConfigurableBeanFactory，提供了灵巧的Configure来配置一个BeanFactory，增加额外的BeanFactory方法，`与Scope一起使用，配置范围`。
* BeanPostProcessor，工厂钩子，用来自定义修改Bean实例的，一般是在Bean实例化完成后使用。`是AOP底层`。
* PlaceHolderConfigureSupport[^3]，自定义占位符实现。
* Yml...Runtime....等等

#### parsing包下
* AbstractComponentDefinition，骨架实现，提供了一个基础班的实现。
* ComponentDefinition，一个描述了BeanDefinitions和BeanReferences之间关系的一种视图[^4]。
* AliasDefinition，别名定义。
* BeanComponentDefinition，定义了BeanDefinition数组，和BeanReference数组，~~通过从BeanDefinitionHolder中获取的数组，以数组下标对应属性值~~
* BaseEntry，是ParseState[^5].Entry接口的实现。
* CompositeComponentDefinition,有一个或多个ComponentDefinition的混合实现
* ConstructorArgumentEntry，是ParseState.Entry接口的实现。
* DefaultsDefinition，是BeanMetadataElement的标记接口，一个空的接口。
* EmptyReaderEventListener，空的ReaderEventLiseter[^6]。
* ProblemReporter，SPI接口，允许工具或者外部processes在解析BeanDefinition的时候处理错误，警告报告。
* FailFastProblemReporter，当发生错误时，允许快速失败的方式处理。
* Location，任意本地资源
* NullSourceExtractor，空的资源接近者，是Null异常的一种策略实现，空接口。

[^1]:使用#getObject()
[^2]:默认是Singleton，可以配置为Prototype
[^3]:`${adc}`,这种占位符的实现
[^4]:Bean在XML中，在<Property>标签中可以使用`ref`关联对象。
[^5]:ParseState是一个基于栈的简单结构，在解析的流程中用于追踪逻辑上的位置，里面存放的是Entry接口。
[^6]:java.util.EventLister接口的实现，读取Component，alias和imports