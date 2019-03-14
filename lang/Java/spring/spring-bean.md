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
> 一般来讲，Spring中的Bean 是通过反射并指定属性来实例化的，但是有些Bean的属性太过复杂，如果按照传统的方式，需要在XML文件配置太多的属性，因此Spring内置了很多FactoryBean（大概70多种）用来实例化特殊的Bean。它们隐藏一些复杂的实例化细节，（类似门面模式的作用），并定义了3个非常便利的方法，getObject(),isSingleton(),getObjectType().
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
* 便利的基础class,当存在属性和元素一对一映射关系时，可以被解析并且PropertyName在Class上可以被配置
* 简而言之，具有访问数据源的能力。

#### DefaultSingletonBeanRegistry
* 一般的注册为分享Bean实例，实现了SingletonBeanRegistry，允许正在注册的单例实例可以被所有的调用者通过Bean Name分享
* 这个class主要作为一个base class为BeanFactory的实现类提供服务，记住，ConfigurableBeanFactory接口继承于SingletonBeanRegistry接口。
* 此接口支持嵌套属性，能够设置无限深度子类属性。

#### PropertyAccessor
* 通用的接口能获取以名称命名的属性，为基础的接口BeanWrapper提供服务。

#### BeanWrapper
* Spring低级别JavaBean结构重要接口。
* 提供分析和操作标准JavaBean的操作：可以get/set赋值属性，获取Property描述，query可读/可写的属性

#### DefaultListableBeanFactory默认的容器实现（注册和获取Bean）


#### config包下
* AbstractAutowireCapableBeanFactory，抽象骨架实现。
* AutowireCapableBeanFactory，BeanFactory的继承类，可以实现autowiring，以及引用Bean后的后置处理器。
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
* ProblemReporter，SPI[^0]接口，允许工具或者外部processes在解析BeanDefinition的时候处理错误，警告报告。
* FailFastProblemReporter，当发生错误时，允许快速失败的方式处理。
* Location，任意本地资源
* NullSourceExtractor，空的资源接近者，是Null异常的一种策略实现，空接口。
* SourceExtractor，简单的策略，允许工具控制bean的Metadata.
* Problem，描述了一个bean Definition的问题，主要是为一个通用的参数通过ProblemReporter做服务。
* ProblemReporter，SPI接口，允许工具或者外部processes在解析BeanDefinition的时候处理错误，警告报告。
* PropertyEntry，是ParseState.Entry接口的实现。
* QualifierEntry，是ParseState.Entry接口的实现。

#### support包下
* AbstractBeanDefinition,
* AbstractAutowireCapableBeanFactory，
* AbstractBeanFactory，BeanFactory的抽象类，提供了ConfigurableBeanFactorySPI的全部功能
  * 这个类提供了一个单例缓存（通过它的base class->DefaultSingletonBeanRegistry）
* FactoryBeanRegistrySupport，为想要控制`FactoryBean`实例的单例注册者提供base class支持。
* AbstractPropertyAccessor，PropertyAccessor接口的抽象实现，提供了所有便利方法的基础实现，实际属性的访问是由子类实现。
* AutowireCandidateQualifier，合格者通过解析自动注入的候选者。就是@Autowire注解的实现。
* AutowireCandidateResolver，一个策略接口，决定了一个特殊的BeanDefinition的资格是否可以作为对于一个特殊依赖的Autowire候选人
* AutowireUtil，工具类包含了各种有用的方法为autowire的bean Factories的实现类。
* BeanDefinitionBuiler，建造者模式为建造BeanDefinition。
* BeanDefinitionDefaults，一个简单的持有属性的默认实现。
* BeanDefinitionReader，一个简单的接口，具体指明了通过Resource和String本地参数加载方法。
* BeanDefinitionReaderUtils，工具类，主要是本地使用。
* `BeanDefinitionRegistry`，保存bean Definition的注册信息接口，例如：RootBeanDefinition和ChldBeanDefinition实例。代表性的BeanFactories是内部协作于AbstractBeanDefinition层。就像Spring配置的内存数据库，主要以Map实现，后续直接从BeanDefinitionRegistry中读取配置信息。
* BeanDefinitionResource，描述Resource包装者为一个BeanDefinition。
* BeanDefinitionValueResolver，帮助类，使用在Bean Factory的实现类，解析包含在BeanDefinition中的实际值，然后应用于一个目标实例，被使用在AbstractAutowireCapableBeanFactory中
* BeanNameGenerator,策略接口为BeanDefinition生成Bean的Name。
* CglibSubclassingInstantiationStrategy，默认的使用在BeanFactories中的实例化策略。
* SimpleInstantiationStrategy，简单的实例化策略。
* InstantiationStrategy，实例化策略接口。这个被拉取出来放进一个策略作为一个多方面接近手段，包含了使用CGLIB去创建subclass
* DefaultBeanNameGenerator，默认BeanNameGenerator实现
* `DefaultListableBeanFactory`，默认的ConfigurableListableBeanFactory和BeanDefinitionRegistry实现类.
* DefaultSingletonBeanRegistry，在上面
* DisposableBeanAdapter，适配器实现了DisposableBean和Runnable接口，提供了各种destroy方法摧毁一个Bean。
* GenericTypeAwareAutowireCandidateResolver。
* GenericBeanDefinition，的目的是为标准Bean提供`一站式`服务。就像任意Bean生命，它允许声明一个类加任意构造函数参数值和属性值。此外，来源于parent bean Definition可以很柔和的通过“parentName”属性配置。并存储XML配置文件。
* RootBeanDefinition，一个RootBeanDefinition定义表明它是一个可合并的bean definition：即在spring beanFactory运行期间，可以返回一个特定的bean。`RootBeanDefinition可以作为一个重要的通用的bean definition 视图`。在Spring2.5以后使用GenericBeanDefinition时更好的动态获取的方式。它可以能是由互相继承的多个原始Bean定义创建的。在这种相互继承的Bean关系中，代表了当前初始化类的父类的BeanDefinition。那么依赖关系是如何实现的呢？在AbstractBeanDefinition(RootBeanDefinition)中，有一个String[]数组（dependsOn）,保存了依赖的BeanName，并在DefaultSingletonBeanRegistry中，有一个Map，保存了BeanName和它之间的依赖关系集合Set<String>,是一个一对多的关系。
* 


* BeanInfoFactory，策略接口，为了spring-bean创建BeanInfo实例




[^0]:Service Provider Interface，服务提供接口
[^1]:使用#getObject()
[^2]:默认是Singleton，可以配置为Prototype
[^3]:`${adc}`,这种占位符的实现
[^4]:Bean在XML中，在<Property>标签中可以使用`ref`关联对象。
[^5]:ParseState是一个基于栈的简单结构，在解析的流程中用于追踪逻辑上的位置，里面存放的是Entry接口。
[^6]:java.util.EventLister接口的实现，读取Component，alias和imports