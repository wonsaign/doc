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
* ClassLoader,就是加载.class文件的java程序或C++程序,分为两类:
    * 一类是`BootStrap`,由C++实现,是虚拟机的一部分
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
* ThreadLocal,是线程的局部变量,每个Thread都有一个ThreadLocalMap[^1],用来存贮<ThreadLoacal,Object>的key,value键值对.
    * 当调用ThreadLocal.get()方法,会将当前ThreadLocal引用作为正在运行Thread中的ThreadLocalMap的key,在Map的Entry[]中检索value值.
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
* List,List<Object>,List<?>
  * List<?>,称为通配符集合,它可以接受任意类型的集合引用赋值,不能add,但是可以remove和clear,一般用来接受外部集合或者返回一个不知道具体元素类型的集合.
* 并发容器CopyOnWriteArrayList,简称COW奶牛容器.读写分离,如果是写操作,复制一个新集合,在新集合内进行删除或添加,待一切修正完成后,将其指向新的集合.优点是,`可以高并发的对COW进行读和遍历`,而不需要加锁.
  * 使用COW的注意事项
    * 1.尽量设置合理的容量初始值,它扩容代价比较大
    * 2.使用批量添加或删除方法的时候,如addAll或者removeAll操作,在高并发请求下,可以攒一下要添加的或删除的元素,避免添加一个元素而复制整个集合.
    * 3.适用于读多写极少的场景.
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



[^1]:ThreadLocalMap 是 ThreadLocal中的静态类
[^2]:不可变类,指的是对象内部的数据不可变,是发生在`内部`的.
