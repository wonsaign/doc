# Spring自定义开发感想
[TOC]

> Spring框架是使用的非常多的框架，尤其是SpringBoot更是主流开发，看了很多Spring架构的代码，但是本着亲自动手，才发现能因为很多思考。

## 需求实现

### 分布式锁放入Spring框架中。TODO： 整理分布式锁的资料
**实现思路**
1. 来源：设计思路来源于Spring Task
2. 模仿实现
```java
// Spring Task使用的是BeanPostProcesser
// BeanPostProcesser是一个特殊的Bean，是所有的Bean在生成的时候，都要被这些Processer“处理”一遍（真刺激，欧洲贵族初夜权？）
// TaskBeanPostProcesser是处理@Schedule注解，那么如果我对定时任务也是用注解的方式，因此思路相同，自己创建BeanPostProcesser

// 最开始，我以为实现了BeanPostProcesser接口，容器会自动识别为Bean，后来发现并不是，需要自己加入注解@Bean，创建方式跟普通对象一样，“new”
@Bean("distributedLockAnnotationProcessor")
@Role(BeanDefinition.ROLE_INFRASTRUCTURE)
@ConditionalOnBean(name = "curatorFramework")
public ReentrantExclusiveDistributedLockBeanPostProcessor distributedLockAnnotationProcessor() {
    return new ReentrantExclusiveDistributedLockBeanPostProcessor();
}



// 后置处理器的代码实现了
public class ReentrantExclusiveDistributedLockBeanPostProcessor implements
        // 为了耍流氓
        BeanPostProcessor,
        // 为了实力化之后
        SmartInitializingSingleton,
        // 为了获取工厂 这种 Aware接口，你设置啥就有啥，牛逼， BeanNameAware, BeanFactoryAware, ApplicationContextAware
        BeanFactoryAware,
        // 为了最后创建为Bean
        Ordered{

    /** 使用注解的Bean过于多，在这里将此缓存可以提高速度 */
    private final Set<Class<?>> nonAnnotatedClasses = Collections.newSetFromMap(new ConcurrentHashMap<>(64));

    Map<String, InterProcessLock> keys = new HashMap<>();

    CuratorFramework curatorFramework;

    private static final String CURATOR_FRAMEWORK = "curatorFramework";

    private static final String PATH_PREFIX = "/";

    @Nullable
    private BeanFactory beanFactory;


    public InterProcessLock getLock(String key){
        return keys.get(getCompleteKey(key));
    }

    private void setLock(String key){
        InterProcessLock lock = new InterProcessMutex(getCuratorFramework(), getCompleteKey(key));
        keys.put(getCompleteKey(key), lock);
    }

    private String getCompleteKey(String key){
        return PATH_PREFIX + key;
    }

    private CuratorFramework getCuratorFramework(){
        if (curatorFramework == null) {
            return beanFactory.getBean(CURATOR_FRAMEWORK, CuratorFramework.class);
        }
        return curatorFramework;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {

        Class<?> targetClass = AopProxyUtils.ultimateTargetClass(bean);

        // 判断@DistributedLock
        if (!this.nonAnnotatedClasses.contains(targetClass) &&
                AnnotationUtils.isCandidateClass(targetClass, Arrays.asList(DistributedLock.class))) {
            // 获取到注解方法
            Map<Method, DistributedLock> annotatedMethods = MethodIntrospector.selectMethods(
                    targetClass,
                    (MethodIntrospector.MetadataLookup<DistributedLock>) method -> {
                        DistributedLock mergedAnnotation = AnnotatedElementUtils.getMergedAnnotation(method, DistributedLock.class);
                        return mergedAnnotation;
                    });
            annotatedMethods.forEach(((method, distributedLock) ->
                    setLock(method.getDeclaringClass().getName() + "." +method.getName())));
        }

        // 好的 你被我用完了 你可以走了
        return bean;
    }

    @Override
    public void afterSingletonsInstantiated() {
        this.nonAnnotatedClasses.clear();
    }

    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        this.beanFactory = beanFactory;
    }

    @Override
    public int getOrder() {
        return LOWEST_PRECEDENCE;
    }

}

```
### 思索  
1. java语法
    1. AbstractAutowireCapableBeanFactory.this 表示当前的抽象类AbstractAutowireCapableBeanFactory的继承实例
2. Aware接口，需要什么资源可以直接实现
    1. BeanNameAware
    2. BeanFactoryAware
    3. BeanClassLoaderAware
    4. EnvironmentAware
    5. EmbeddedValueResolverAware实现该接口能够获取Spring EL解析器，用户的自定义注解需要支持spel表达式的时候可以使用，非常方便
    6. ApplicationContextAware
3. ApplicationListener
    1. ContextClosedEvent
    ```java
    调用在容器关闭的时候,kill 容器也会调用
    ```
    2. ContextRefreshedEvent
    ```java
    在Spring容器中的12步骤最后一步finishRefresh
    会推送事件
    publishEvent(new ContextRefreshedEvent(this));
    并被调用
    ```
    3. ContextStartedEvent
    ```java
    ConfigurableApplicationContext context = SpringApplication.run(XXX.class, args);
    // 显式调用开始事件
    context.start(); 
    ```
    4. ContextStoppedEvent
    ```java
    ConfigurableApplicationContext context = SpringApplication.run(XXX.class, args);
    // 显式调用结束事件
    context.stop(); 
    ```
4. ImportBeanDefinitionRegistrar，需要@Import注解补充
```java
// 原理是通过@Configuration解析的时候，会解析@Import中的Class
@Configuration
@Import(ImportBeanDefinitionRegistrarTest.class)
public class ConfigImportBeanDefinitionRegistrarTest {
}

// Spring中很多的内置处理器都是在这里完成的
beanName:org.springframework.context.annotation.internalConfigurationAnnotationProcessor
beanName:org.springframework.context.annotation.internalAutowiredAnnotationProcessor
beanName:org.springframework.context.annotation.internalCommonAnnotationProcessor
beanName:org.springframework.context.event.internalEventListenerProcessor
beanName:org.springframework.context.event.internalEventListenerFactory
```
5. 生命周期
    1. InitializingBean
    2. DisposableBean
6. 执行顺序，由于BeanPosteProcessor这些贵族都要那啥，但是也要有个先后次序
    1. PriorityOrdered 贵族头子，拥有最先权
    2. Ordered 普通贵族
    3. 没有`order`的最后赏点油水
7. 生命周期图
![Bean的生命周期](http://tva1.sinaimg.cn/large/006jbqSUly1guxcwnoi2yj61oi14injt02.jpg)


