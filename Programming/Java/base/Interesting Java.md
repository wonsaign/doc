## Interesting Java
* 多重注解
* int.class,Integer.TYPE==int.class,表示的就是int类型（实际是int类型的字节码）
* Integer.valueOf(i)方法,
    * -128 >= i >= 127范围内,都被放在一个Integer[] cache的数组内,所以可以用地址比较符(==)比较,返回是true
    * 超过上述范围,都是new Integer(),地址比较符(==)返回不同的比较地址,所以是false 
* 代理模式和适配器模式
* springboot 内置tomcat如何启动
* 一个请求流程,如何在tomcat服务器内执行
* nio/bio
* ClassLoader,就是加载.class文件的java程序或C程序,分为两类:
    * 一类是`BootStrap`,由C实现,是虚拟机的一部分
    * 另外一类是`其他加载器`,也是java程序,并全部继承java.lang.ClassLoader,`这些加载器`的启动`由BootStrap加载器`先`加载`到内存后才能去加载其他的类.
        * BootStrap ClassLoader:负责加载`JDK/jre/lib`目录下的二进制Class文件
        * Extension ClassLoader:负责加载`JDK/jre/lib/ext`目录下的二进制Class文件
        * Application ClassLoader:负责加载`ClassPath`目录下的二进制Class文件,一般用户开发使用的都是该类加载器,由IDE生成对应的classpath路径,使Application ClassLoader能够根据路径加载程序,一般是默认的类加载器.
* Java Application ,java应用程序,为什么说tomcat是应用服务器呢?因为它就是java写的,eclipse也是,启动这两个程序需要运行Java程序中的Main函数,这是程序的唯一入口,在函数中启动线程查找所有系统变量并初始化加载让程序一直存活,利用CPU线程的特性(程序执行的最小单位).
* final关键字:
    * 修饰类,方法:禁止继承
    * 修饰成员变量:代表常量,一旦赋值不可修改
* 值对象和引用对象(注意不是值引用和对象引用)
    * 值对象要保证不可变性[^2](如人和指纹,是一种`组合`关系,具有`相同的生命周期`)
* 线程的几种状态
* 接口和抽象类 `接口like-a 抽象类is-a;接口多实现,抽象类单一继承;接口不能有实现不能私有,抽象类可以有`
* group by having,按照年龄段,select (select ... 按照条件筛选年龄) a group by 
* HashMap源码
* Redis锁以及两种序列化的区别,
    * AOF:将每一个收到的写命令都通过write函数追加到文件中(默认是 appendonly.aof)。实时,有序易懂,但是体积大,重启加载默认选择RDB
    * RDB:适合备份,文件格式紧凑体积小,实时性差,适合恢复大量数据
* Redis事务:
    * Transaction t =	jedis.multi();// 开启事务
    * t.exec();// 结束事务
* 重构的方法
* 正则表达式
* 线程可见性
* 静态内部类与非静态内部类
    * 静态:静态内部类是当前类`本身的属性`,如ThreadLocal.ThreadLocalMap,不与这个类的`实例`相关
    * 静态内部类不想访问外部类的属性，所以定义为静态；如果想要访问外部类属性，则直接使用内部类即可。
* 静态内部类与普通类,最主要的区别在于`可见性`(public,default,protected,private)
* 查看日志中包含某一个关键字的Linux 语句 `grep -rn "abc" *`
* tomcat 原理解析
* 跨域:简单来说A网站的JavaScript试图访问B网站的资源,解决方式CORS跨域资源共享
* a+=b和a=a+b,区别在于`前者会隐式的把运算结果转换为a数据类型 ,后者不会`
* sleep和wait的区别
    * sleep:Thead的静态方法,是用来控制自身的;sleep不会放弃锁;使用无限制;必须捕获InterruptException,允许在其他线程调用interrupt()方法时,`打断`当前线程并`提前`从sleep中wake up,并对异常捕获提前返回.
    * wait:是Object方法,用于线程之间通信;wait会放弃锁;必须放在同步方法/代码块中;
* 线程实现的方法,
    * 继承Thread,其实Thread类也是实现了runable接口,并且run方法也是要求自定义实现的
    * 实现runnable接口
    * 实现callable接口,属于exccutor框架中的功能类,是runnable接口的升级版,在jdk1.5以后有的
* 线程同步实现的方式:sychronnized;wait/notify;lock
* 同步方法和同步代码块的区别:
    * 同步代码块使用的是管程(monitor);
    * 同步方法是从JVM方法常量池中的方法表结构(method_info Structure) 中的 ACC_SYNCHRONIZED 访问标志区分一个方法是否同步方法
* ThreadLocal,是线程的局部变量,每个Thread都有一个ThreadLocalMap[^1],用来存贮<ThreadLoacal,Object>的key,value键值对.从概念上看`可以将ThreadLocal<T>看做Map<Thread,T>`.
    * 当调用ThreadLocal.get()方法,会将当前ThreadLocal引用作为正在运行Thread中的ThreadLocalMap的key,在Map的Entry[]中检索value值.简而言之：get方法总是返回当前线程使用set方法设置的最新值。ThreadLocal的值会随着线程的消亡而被垃圾回收，所以在使用线程池的时候（线程不会消亡），总是在end时清除保存的值，总是在begin时set值。
    * 应用：实现应用程序框架的时候被大量使用
    * 伪代码:
    ```
    public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null) {
                @SuppressWarnings("unchecked")
                T result = (T)e.value;
                return result;
            }
        }
        return setInitialValue();// 没有就初始化
    }
    ThreadLocalMap getMap(Thread t) {
        return t.threadLocals;
    }
    private T setInitialValue() {
        T value = initialValue();// initialValue()默认为:null
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
        return value;
    }
    ```
* Spring MVC工作原理
* 重载和覆盖的区别:重载是`水平`方向上的,参数不同;覆盖是`垂直`方向上的,返回值参数值相同,抛出异常必须是同类或者子类,不能是private
* 多线程沟通:
    * Object->notify/wait;
    * Lock->Condition 
* MySQL和MongoDB比较
    * MySQL
    * MongoDB:
        * 文档数据库,可以存放JSON,XML,BSON
        * 适合场景：
            * 高负载:频繁插入
            * 高可用:主从模式
            * 大数据:分片存储5G~10G的数据
            * 基于位置的数据查询:支持二维空间索引
            * 非结构化数据的爆发增长:增加一个字段或者少一个对以前的数据都无影响
            * 事件的记录，内容管理或者博客平台等等,数据具体格式无法确定。
        * 数据处理：数据是存储在硬盘上的，HOT数据被加载到内存中，从而达到高速读写。
        * 支持fail-over
        * 占用空间比较大
        * 本身不支持事务
        * 自带map-reduce,sharding
* Java中isAssignableFrom的用法(是native函数)，A.class.isAssignableFrom(B.class),表示A类（或接口）是否是B类（或接口）一样，或者是B类的超类（或超接口），是返回true。
* 接口和抽象类
  * 抽象类is-a,虽然关键字是interface但是编译后仍是.class.
  * 接口can-do,抽象类是二当家,接口位于顶层,而`抽象类对各个接口进行了组合,然后实现部分接口的行为`
* 内部类,相当于类中的一个属性.
* super()方法,指的是默认的父类无参构造函数,必须出现在构造方法的第一行.
* 静态代码块只会执行一次,为什么呢?因为静态代码是与class相关联的而不是实例,第一次是因为要放入常量池.
* Override和Overload
  * java覆写(Override)必须是方法名参数一样才可以.
  * java重载(Overload),其有几种准测
    1.精确匹配,当int,Integer,Integer...,Object同时存在时,精确匹配
    2.m1(long)可以接受int类型;m1(int)不可以接受int类型
* 泛型
  * 泛型类，可以看做普通类的工厂
  * 泛型类中，不能使用静态泛型类变量。  
  * 泛型中E,T,K,V
    * E,Element
    * T,the Type of object
    * K,key
    * V,value
  * 泛型方法中的的尖括号<>,
    * 如<String>,尖括号中的每一个元素代表了一种未知类型
    * <>未知非常讲究,必须是返回值之前或者类名之后
    * 泛型在`定义处`,只具备执行Object的能力.所以<String,Integer>String get(String s, Integer i),调用的时候可以传入get(123,"abc");但是参数s中的方法s.intValue是做不到的.
    * 类型擦除:编译之后的字节码指令,上面的get方法中的参数全部擦除为Object,返回类型也是Object,<String,Integer>没有这些花头花脑的方法签名.全部是(Ljava/lang/Object;Ljava/lang/Object;),泛型的目的是在编译器提醒程序员安全使用和放置数据.
* 数据类型的使用规范
  * 所有POJO类属性必须使用包装类数据类型
  * RPC方法的返回值和参数必须使用包装数据类型
  * 所有的局部变量推荐使用基本数据类型
* 在任何情况下都要显示指定容器容量.
* `数组是一种顺序表`.是表结构,划重点.
* 集合
  * 集合结构图
  ![collection](../../Images/programming/java/java_collection.png)
  * List<?>,称为通配符集合,它可以接受任意类型的集合引用赋值,不能add,但是可以remove和clear,一般用来接受外部集合或者返回一个不知道具体元素类型的集合.
  * 并发容器CopyOnWriteArrayList,简称COW奶牛容器.读写分离,如果是写操作,复制一个新集合,在新集合内进行删除或添加,待一切修正完成后,将其指向新的集合.优点是,`可以高并发的对COW进行读和遍历`,而不需要加锁.
  * 使用COW的注意事项
    * 1.尽量设置合理的容量初始值,它扩容代价比较大
    * 2.使用批量添加或删除方法的时候,如addAll或者removeAll操作,在高并发请求下,可以攒一下要添加的或删除的元素,避免添加一个元素而复制整个集合.
    * 3.适用于读多写极少的场景.
  * 集合实现了Collection接口，这个接口中定义了迭代器Iterator。
  * 使用Iterator的remove时候要注意，要先使用it.next(),才可以remove(),因为remove会删除上次调用的Element.


* 树
  * 二叉查找树
    * 前序,中序,后序遍历左节点一定是在右节点之前遍历
    * 前序:根,左,右;中:左,中,右;后:左,右,中;
    * AVL树和红黑树 
      * AVL是绝对平衡树,左右子树高度相差不为1,面对低频修改和大量查询用AVL树
      * 红黑树保证的是从根节点到叶子节点最长的路径不超过最短路径的2倍,是相对(大体上)平衡树,面对频繁插入和删除红黑树更合适
* Map
  * TreeMap依靠Compareable或者Comparator来实现Key去重
  * HashMap依靠hashMap和equals去重 

* Thread
  * 一旦一个线程开始运行，它不必始终保持运行。事实上，运行中的线程被中断，目的是为了让其他线程获得运行机会。记住，在任何给定时刻，一个可运行的线程可能正在运行也可能没有运行（这就是为什么将这个状态称为可运行而不是运行）
    * 守护线程，守护线程的唯一用途就是为其他线程服务，比如计时线程，当只剩下守护线程的时候，虚拟机就退出了。`守护线程应该永久不会去访问固有资源，如文件，数据库，因为他们可能在任一时刻的一个操作而发生中断`。
    * `线程安全`，从下面结果维度上来说明
      * 锁
        * ReentrantLock[^4]（重入锁）的lock/unlock，这与synchronized是一样的，但是更加灵活
        * Object的wait/notify  <==>  Condition的await/signalAll方法是一样的
          * 高级应用：
            * blocking queue，阻塞队列
            * 同步器：
              * CyclicBarrier：允许线程集等待直至其中预定数目的线程到达一个公共障栅（ barrier)，然后可以选择执行一个处理障栅的动作
              * Phaser：类似于循环障栅， 不过有一个可变的计数
              * CountDownLatch：允许线程集等待直到计数器减为0
              * Exchanger：允许两个线程在要交换的对象准备好时交换对象
              * Semaphore：允许线程集等待直到被允许继续运行为止
              * SynchronousQueue：允许一个线程把对象交给另一个线程
      * synchronized
        * monitor，监视器，是native方法
        * 高级应用：
          * ConcurrentHashMap，ConcurrentLinkedQueue等线程安全集合
      * final
        * final域不可改变
      * 原子变量 
      * volatile
        * 使用方式：因为提供了“可见性”，所以对于“只读”判断非常好用，但是不建议赋值修改（如果更新，建议使用单线程）。
        * 每个线程都有独占的内存区域，如操作栈、本地变量表等。线程本地内存保存了引用变量在堆内存中的副本，线程对变量的所有操作都在本地内存区域中进行，执行结束后再同步到堆内存中去。这里必然有一个时间差，在这个时间差内，该线程对副本的操作，对于其他线程都是不可见的。当使用volatile修饰变量是,此变量的操作都是在内存中进行,不会产生副本.
        * 它是轻量级的线程操作可见方式,并非同步方式.适合`一写多读`的并发场景,如CopyOnWriteArrayList.
        * `happen-before`原则(先于):是时钟顺序的先后
          * 程序顺序规则:一个线程中的每个操作,happen-before于改线程中的任意后续操作;
          * 对一个监视锁的解锁,happen-before于随后对这个监视锁的加锁;
          * 对一个volatile域的写,happen-before于任何后续对这个volatile域的读;
          * a happen-before b,且b happen-before c,那么a happen-before c
        * 指令重排(优化,写操作不会重排,但是赋值和读操作可能会重排):
          * 以生活为例,A去换从图书馆借的α书,并且再借一本β书;同寝室室友B正好也有一本书γ要还,并且还想接一本δ;那么按照正常人的惯例,A会将B的γ书和自己借的书α一起还给图书馆,然后借出两本书β和δ.
          * 计算机的也有类似的优化.比如
          ``` 
              int a = 1;
              int b = 2;
              int c = 3;
              x = x + 1;
          ```
          优化后为:
          ``` 
              int b = 2;
              int c = 3;
              int a = 1;
              x = x + 1;
          ```
    * 执行器
      * 线程池
        * 普通线程池：ExecutorService
        * 定时线程池：ScheduledExecutorService
        * 控制任务组：ExecutorCompletionService，传统线程池ExecutorService执行一组任务（List<Task>）时需要将？？？？
        * Fork-Join 框架：分解子任务
        * CompletableFuture：自定义线程之间执行顺序以及结果传递等操作
      * ThreadPoolExecutor源码参数
          * 核心参数
          * corePoolSize,表示常驻核心线程数,如果等于0,执行完任务之后,线程池中的线程会自动销毁;如果大于0,则不会销毁数字内的核心线程
          * maximumPoolSize,表示线程池能容纳同事执行的最大线程数.必须大于或者等于1,如果等于corePoolSize则是固定大小的线程池.
          * keepAliveTime,表示线程池中的线程空闲时间,当空闲时间达到keepAliveTime值时,线程会被摧毁,直到只剩下corePoolSize个线程为止.
          * TimeUnit
          * workQueue表示缓存队列.当请求线程数大于maximumPoolSize时,线程进入BlockingQueue阻塞队列.
          * threadFactory表示线程工厂,它用来成产一组相同任务的线程.
          * handler表示执行拒绝策略的对象,默认使用AbortPolicy()[^3],当任务缓存区上限的时候,就可以使用拒绝策略处理请求.
          * ThreadLoacl,在上面有讲述.

* java中main方法启动的是一个进程还是一个线程?
  * 是一个线程也是一个进程，一个java程序启动后它就是一个进程，进程相当于一个空盒，它只提供资源装载的空间，具体的调度并不是由进程来完成的，而是由线程来完成的。一个java程序从main开始之后，进程启动，为整个程序提供各种资源，而此时将启动一个线程，这个线程就是主线程，它将调度资源，进行具体的操作。Thread、Runnable的开启的线程是主线程下的子线程，是父子关系，此时该java程序即为多线程的，这些线程共同进行资源的调度和执行。
  * 代码如下 
    ```
      public static void main(String[] args) throws IOException, InterruptedException {
        String name = ManagementFactory.getRuntimeMXBean().getName();
        System.out.println(name);
        String pid = name.split("@")[0];
        System.out.println("Pid is:" + pid);
        
        System.err.println("进程中主线程ID="+Thread.currentThread().getId());
        
        Thread t1 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(60000);
                    System.out.println(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        t1.start();
        System.err.println("进程中子线程T1的ID="+t1.getId());

        Thread t2 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(60000);
                    System.out.println(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        t2.start();
        System.err.println("进程中子线程T2的ID="+t2.getId());
    }
    ```
    * 上述代码会输出，可以看出进程中必定有一个线程，它就是主线程，而且线程id为`1`
    ```
        1044@2013-20180318IJ
        Pid is:1044
        进程中主线程ID=1
        进程中子线程T1的ID=11
        进程中子线程T2的ID=12
    ```

    
* 程序，进程，线程的关系？
* List代表了线性结构，而线性结构的实现方式是两种
  * 数组，物理上连续的内存空间，所以ArrayList的增加方式不断的扩容，开辟新的空间，copy元素
  * 链表，物理上不连续，逻辑上连续
  * 队列
    * 栈（堆栈），同样是线性结构
      * 数组实现
      * 链表实现
    * 队（队列），也是线性结构
      * 数组实现，这里将数组变成一个“首位相接”的闭环，可以高效利用队列，减少因为数组特性出栈时所有元素前移一位，将`数组逻辑闭环`就可高效使用，原理是添加栈顶和栈尾位置指针，入栈出栈时候分别移动栈尾和栈顶指针的位置，就可以。那么如何判断闭环数组是null还是full，两种方式；
        * 方式一，留一下一个空位置，这样栈顶和栈尾指针永远不会相等，相等时候就是空队列
        * 方式二，使用一个标识标识空或者满。



[^1]:ThreadLocalMap 是 ThreadLocal中的静态类
[^2]:不可变类,指的是对象内部的数据不可变,是发生在`内部`的.
[^3]:总是抛出RejectedExecutionExcepiton异常来终止线程
[^4]:可重入锁，当一个线程进入一个锁的同步代码块的时候，锁的计数器加1，当线程退出同步代码块数量-1.（注意Synchronized和ReentrantLock，都是重入锁）
