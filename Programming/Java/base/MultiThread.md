## Multi Thread
---

#### 计算机内存模型
* 下面动图展示了CPU与内存的关系,图中没有标明服务总线(主板)
* MESI高速缓存协议,提高了并发效率.
   * MESI的含义,CPU中每个缓存行（Cache line)使用4种状态进行标记（使用额外的两位(bit)表示):
     1. M(Modified)   这行数据有效，数据被修改了，和内存中的数据不一致，数据只存在于本Cache中。(修改)
     2. E(Exclusive)  这行数据有效，数据和内存中的数据一致，数据只存在于本Cache中。(独占)
     3. S(Shared)     这行数据有效，数据和内存中的数据一致，数据存在于很多Cache中。(共享)
     4. I(Invalid)    这行数据无效.。(无效)
   * MESI失效的原因
     1. Cache line 数据量太大超过了一行限制
     2. 当前CPU不支持MESI
   * 图示多线程说明,M,E,S,I简单的切换.
  ![MESI](../../../Images/programming/java/base/MESI总线一致性协议.gif)

#### Java内存模型-JMM(Java Memory Model)
* JMM内存模型,其实是借鉴于操作系统的多线程模型.
* 用户线程(ULT),内核线程(KLT).
  * **用户线程ULT**:指不需要内核支持而在**用户程序中实现**的线程，其不依赖于操作系统核心，应用进程利用线程库提供创建、同步、调度和管理线程的函数来控制用户线程。另外，用户线程是由应用进程利用线程库创建和管理，不依赖于操作系统核心。不需要用户态/核心态切换，速度快。操作系统内核不知道多线程的存在，因此一个线程阻塞将使得整个进程(包括它的所有线程)阻塞。由于这里的处理器时间片分配是以进程为基本单位，所以每个线程执行的时间相对减少。
  * **内核线程KLT**:线程的所有管理操作都是由**操作系统内核完成**的。内核保存线程的状态和上下文信息，当一个线程执行了引起阻塞的系统调用时，内核可以调度该进程的其他线程执行。在多处理器系统上，内核可以分派属于同一进程的多个线程在多个处理器上运行，提高进程执行的并行度。由于需要内核完成线程的创建、调度和管理，所以和用户级线程相比这些操作要慢得多，但是仍然比进程的创建和管理操作要快。大多数市场上的操作系统，如Windows， Linux等都支持内核级线程。

* 那么基于两种线程类型,有几种线程模式
    * **内核线程实现**,程序一般不会直接使用内核线程，而是使用内核线程的一种高级接口——轻量级进程(Light Weight Process，LWP)，轻量级进程就是我们通常意义上所讲的线程，由于每个轻量级进程都由一个内核线程支持，因此只有先支持内核线程，才能有轻量级进程。由于LWP是由操作系统调用CPU创建的线程,所以是真正的线程,资源非常宝贵.这种轻量级进程与内核线程之间**1:1**的关系称为一对一的线程模型.轻量级进程也具有它的局限性:
      1. 由于是基于内核线程实现的，所以各种线程操作，如创建、析构及同步，都需要进行系统调用。而系统调用的代价相对较高，需要在用户态(User Mode)和内核态(Kernel Mode)中来回切换。
      2. 每个轻量级进程都需要有一个内核线程的支持，因此轻量级进程要消耗一定的内核资源(如内核线程的栈 空间)，因此一个系统支持轻量级进程的数量是有限的。
    * **用户线程实现**的方式被称为1:N实现。广义上来讲，一个线程只要不是内核线程，都可以认为是用户线程(User Thread，UT)的一种，因此从这个定义上看，轻量级进程也属于用户线程，但轻量级进程的实现始终是建立在内核之上的，许多操作都要进行系统调用，因此效率会受到限制，并不具备通常意义上的用户线程的优点。
* **java目前使用的的是内核线程实现,golang使用的是用户线程实现(golang中叫协程)**
  
* JMM模型图(图中可以看出使用的是1:1模型)
  ![JMM](../../../Images/programming/java/base/JMM内存模型.png)
* 线程上下文切换.
  ![线程上下文切换](../../../Images/programming/java/base/线程上下文切换.png)
* JMM-同步八种操作介绍
  1. lock(锁定):作用于主内存的变量，把一个变量标记为一条线程独占状态 
  2. unlock(解锁):作用于主内存的变量，把一个处于锁定状态的变量释放出来，释放后的变量才可以被其他线程锁定 
  3. read(读取):作用于主内存的变量，把一个变量值从主内存传输到线程的工作内存中，以便随后的load动作使用 
  4. load(载入):作用于工作内存的变量，它把read操作从主内存中得到的变量值放入工作内存的变量副本中 
  5. use(使用):作用于工作内存的变量，把工作内存中的一个变量值传递给执行引擎 
  6. assign(赋值):作用于工作内存的变量，它把一个从执行引擎接收到的值赋给工作内存的变量 
  7. store(存储):作用于工作内存的变量，把工作内存中的一个变量的值传送到主内存中，以便随后的write的操作 
  8. write(写入):作用于工作内存的变量，它把store操作从工作内存中的一个变量的值传送到主内存的变量中.

  ![Java线程模型](../../../Images/programming/java/base/Java线程模型.png)

#### volatile关键字
* 底层原理: 
```
  volitile关键字,实际上会在底层汇编语言中生成`#Lock`指令
  其含义就是调用了MESI服务总线来帮助监督使用了volatile的变量,一旦有‘M’操作,在合适的时机‘I’其他线程中的变量.

  ---
  滥用volitile关键字活着CAS,会引起‘总线风暴’(总线操作的太多了)
```

* 可见性:实际上就是调用MESI缓存一致性协议,所以保证了可见行
* 指令不能实现线程安全的原因是:
  ```
  上面动图说明了,当一旦有一个`M`操作,其他线程中的变量全部变`I`
  即使变为`I`,但是也是进行了一次操作,此次操作就是无效化的,所以不会修改内存中的变量值.
  所以5w次的volatile变量每次都加1,就会因为某次无效化,而导致结果<=5w
  ```
* 指令重排
> volatile禁止指令重排的本质上是使用的内存屏障(read-store)
> java语言规范规定JVM线程内部维持顺序化语义。即只要程序的最终结果与 它顺序化情况的结果相等，那么指令的执行顺序可以与代码顺序不一致，此过程叫指令的重排序
  * 什么情况下产生指令重.
    1. as-if-serial语义:JVM的JSR-133规范中定义了as-if-serial语义，即compiler, runtime, and hardware三者需要保证在单线程模型下程序不会感知到指令重排的影响
    2. 重排序引发的问题
    ```
    1. public class Singleton {
    2.  private static Singleton instance = null;
    3.  private Singleton() { }
    4.  public static Singleton getInstance() {
    5.   if(instance == null) {
    6.        synchronzied(Singleton.class) {
    7.          if(instance == null) {
    8.              instance = new Singleton();  
    9.          }
    10.        }
    11.     }
    12.     return instance;
    13.   }
    14. }
    ----
    在极高并发的情况下,由于instance = new Singleton();并不是原子操作,它实际上是分为了3个步骤
    memory = allocate();   //1：分配对象的内存空间
    ctorInstance(memory);  //2：初始化对象
    instance = memory;     //3：设置instance指向刚分配的内存地址
    如果步骤2和3相互颠倒(被重排序了),先赋值了地址,再实例化(在单线程下,确实不会影响结果)
    此时多线程如果走到了第5行,发现已经有了实例了,所以会返回一个没有初始化的实例对象,从而引发不可预期的后果.
    ----
    解决办法
    第2行声明为volatile
    ```
* 内存屏障(**内存屏障是硬件层的**)
> 硬件层的内存屏障分为两种：Load Barrier 和 Store Barrier即读屏障和写屏障。
  * 在开始讲之前先说明,什么是load和store
    * a=1,是store操作
    * x=a,是先load,然后再store
    * 然后,使用了volatile变量以后,会在代码上前后加上内存屏障.具体添加的规则是:
    ![指令重排表](../../../Images/programming/java/base/指令重排表.png)
    * 添加之后的结果是:
    ![指令重排结果](../../../Images/programming/java/base/指令重排结果.png)

#### Synchronized关键字
> Synchronized对应着JMM-同步八种操作中的lock和unlock
> 它使用Monitor实现.
* 通过编译为字节码发现,会使用monitorenter和monitorexit在同步代码块的开始和结束位置加入.
  * 下面是加锁过程
  ![加锁过程](../../../Images/programming/java/base/monitor加锁过程.png)
* synchronized锁的几种情况,使用的管程,是作用在对象身上的.
  ```
  在A class对象内的有几个方法

  public static synchronized method(){} //当前类对象的锁
  public synchronized method(){}  // this对象的锁
  synchronized(object){} //object锁
  ```
* 锁粗化
  ```
    // 每个sb.append内部都有一个锁,所以在此方法,会在第一个append和最后一个append加锁,就是锁粗化.
    StringBuilder sb = new StringBuilder();
    sb.append(1);
    sb.append(1);
    sb.append(1);
    sb.append(1);
    sb.append(1);
    sb.append(1);
  ```
* 锁消除
  ```   
    比如下面的代码,根据逃逸分析,所以这个锁就会被消除
    public void t(String key){
        // 按照逃逸分析的原理，new Object()，只能被当前线程访问，所以当前这个锁会被消除
        // synchronized (key){
        synchronized (new Object()){
            System.out.println("你好哇");
        }
    }

  ```
* JVM内置锁,膨胀升级(monitorenter时,会由选择最轻松的加锁方式1->4膨胀升级,尽量选择同步排斥最低级的)
  1. 无锁
  2. 偏向锁,当前对象只有一个线程在访问
  3. 轻量级锁,竞争不激烈,交替进行.(竞争线程数量少，锁持有时间短，能通过自旋获取锁),**自旋不会放弃CPU使用权**,自旋次数可以设置.
  ![加锁过程](../../../Images/programming/java/base/轻量级锁自旋.png)
  4. 重量级锁,会从用户态切换到内核态,消耗比较大.(竞争线程数量多，锁持有时间长),**线程会阻塞**.
  * 锁升级....
* Synchronized和CAS
  * 悲观锁:synchronized采用的是CPU悲观锁机制,即线程获得的是独占锁,虽然经过了优化,但是最终如果升级成重量锁...**就会使其他线程阻塞等待,造成CPU上下午切换**
  * 乐观锁:就是CAS了不会阻止线程竞争.

#### 逃逸分析
> 如果一个对象只能被一个线程访问到,也就是说当前实例对象的生命周期完全在这个方法线程内，会进行逃逸分析，分析后进行优化，对象的实际就创建在栈内了，减少对象占用内存空间

#### Thread的重点难点
* Blocked(线程状态)
A thread that is blocked waiting for a monitor lock is in this state.
* Waiting(等待其他线程来唤醒,并不是线程的状态.类似RUNNABLE状态)
A thread that is waiting indefinitely for another thread to perform a particular action is in this state
下面是来自stackoverflow中的回答
Once this thread is notified, it will not be runnable. It might be that other threads are also notified (using notifyAll()) or the first thread has not finished his work, so it is still blocked till it gets its chance. This is called Blocked State. A Blocked state will occur whenever a thread tries to acquire lock on object and some other thread is already holding the lock.
解释为:
一旦线程被唤醒,它将不是`可执行的状态`.也许是其他线程也被唤醒了或者第一个线程还没有完成它的工作,因此它将被一直阻塞直到获取机会.
这种状态被成为阻塞状态.一个阻塞状态将发生在一个线程尝试获取对象锁并且其他线程已经持有了这把锁.
* **interrupt** 中断线程，并不代表了线程不会运行，而且可以设置的一种状态，可以通过判断线程是否可以中断而跳出死循环
  * interrupt() 它基于「一个线程不应该由其他线程来强制中断或停止，而是应该由线程自己自行停止。」思想，是一个比较温柔的做法，它更类似一个标志位。其实作用不是中断线程，而是「通知线程应该中断了」，具体到底中断还是继续运行，应该由被通知的线程自己处理。
  * interrupt() 并不能真正的中断线程，这点要谨记。需要被调用的线程自己进行配合才行。也就是说，一个线程如果有被中断的需求，那么就需要这样做：
    1. 在正常运行任务时，经常检查本线程的中断标志位，如果被设置了中断标志就自行停止线程。
    2. 在调用阻塞方法时正确处理InterruptedException异常。（例如：catch异常后就结束线程。）
  * interrupted和isInterrupted(判断线程是否中断)
    * interrupted() is static and checks the current thread. isInterrupted() is an instance method which checks the Thread object that it is called on.
    * 下面两个简单小代码,便足以说明问题.
      Thread.interrupted(); // 静态方法
      Thread.currentThread().isInterrupted(); // 实例方法
* Thread.yield()
* Thread.sleep() 通过据visvalVM可以看到,sleep的线程不会占有cpu的使用时间.
  * Thread.sleep(0),意思是让当前cpu放弃一下时间片,让其他线程有机会优先执行,相当于一个让位操作.
  * 另外synchronized中的管程阻塞队列中的线程也会让出时间片.
  * 只有for(;;) 和 while(true)这种自旋的才会一直持有cpu的时间片.

#### Java.util.concurrent
> 由道戈李大师,写的java.util.concurrent,实现了自定义控制锁.
> 其核心是AbstractQueuedSynchronizer(简称AQS)
* 其基本原理:
  1. 将线程通过Node结点包装,
  2. 然后维护一个双向Node链表控制并发时,其他等待的线程.
  3. **使用unsafe魔术类,直接越过jvm直接操作操作系统进行CAS操作.**
  4. **通过使用线程interrupted属性,来控制判断线程并发,入栈等等等详细操作.**
* 线程的阻塞和恢复主要使用**Unsafe.park**和**Unsafe.unpark**
* 下面是AQS中的主要属性,以及ReentrantLock的简单加锁流程
  ![AQS](../../../Images/programming/java/base/ReentrantLock.png)

##### 独占锁工具1:ReentrantLock 
> 主要通过CAS原来加维护AQS中的链表,达到同步.
> 使用阻塞队列,在CLH同步队列用到了node的prev和next
* 下面是AQS中,ReentrantLock中lock方法,包含`添加等待`(addWaiter),`链表如何连接`的,`同步锁是如何唤醒下一个线程`的
![AQS线程等待+唤醒](../../../Images/programming/java/base/AbstractQueuedSynchronizer-Node.png)

##### 共享工具1:Semaphore信号量 
> 信号量,类似限流装置,允许同一时间最多只有N个线程并发
> 比如Semaphore semaphore = new Semaphore(2);最多只有两个线程并发.
> > 使用阻塞队列,在CLH同步队列用到了node的prev和next
* 源码流程图
  * 下面是信号量的`semaphore.acquire()`和`semaphore.release()` 获取许可和释放许可的流程.另外请注意红色箭头,信号量的unpark不一定是通过semaphore.release()调用的,有可能是在`semaphore.acquire()`中的doAcquireSharedInterruptibly()->setHeadAndPropagates调用的
  ![Semaphore](../../../Images/programming/java/base/Semaphore.png)
  * 另外下面是信号量,unpark时机,以及注意点,主要是注意`Head结点`的信号灯,以及为何`semaphore.acquire()`中的doAcquireSharedInterruptibly()->setHeadAndPropagates掉用unpark后,`semaphore.release()` 就不会再次调用.
  ![Semaphore-story](../../../Images/programming/java/base/Semaphore-Story.png)

##### 共享工具2:CountDownLatch倒计时锁 
> 使用阻塞队列,在CLH同步队列用到了node的prev和next
* Countdownlatch是**减法操作**,**不可逆**
  1. 比如声明了10个线程,当前计数器为10 -> CountDownLatch countDownLatch = new CountDownLatch(1)0;
  2. 并通过awaitpark(挂起)主线程 -> countDownLatch.await();
  3. 每个线程完成后调用countDown方法,计数器减1 -> countDownLatch.countDown();
  4. 当10个线程前部完成,计数器等于0时, await不再park(挂起)主线程,继续执行.
* 特点:先park(挂起),后放行. while do
  ```
    类似的代码含义就是
    Main thread wait();
    int count = 10;
    while(count <= 0){
      thread work;
      count—-;
    }
    Notify Main thread;
  ```
* 项目使用经验,之前的`个人工作台`,由于接口内数据众多,单个线程串行执行会导致过慢,使用CountDownLatch,使用线程异步执行分担出一部分压力,将接口相应时间变短.
  * why使用CountDownLatch?
  * 因为分出去的线程执行了一部分业务逻辑,并将结果`res.setXXXResult(xxxdata)`中,最终通过return `res`将异步计算结果返回
  * 但是由于异步结果相应速度比主线程要慢,所以`res`先与异步线程返回,导致返回结果丢失
  * 于是,就需要在返回结果(return `res`)之前,在此设置一个屏障,等待异步线程结果计算结束.
  * why不使用CyclicBarrier?CyclicBarrier也能实现此功能
  * 因为CyclicBarrier是可以循环利用的屏障,而本次业务不需要循环屏障.

##### 共享工具3:CyclicBarrier循环屏障
> 使用阻塞队列,在CLH同步队列用到了node的prev和next
* Cyclicbarrier是加法操作,**可逆**
  1. 比如声明了10个线程,当前计数器为0,
  2. 当10个线程每个完成后调用await方法park(挂起)当前线程,计数器加1
  3. 当计数器等于10.唤醒所有park(挂起)的线程继续执行.
* 我觉得多个线程一起执行,达到某个点停下来等待这个,定时任务分配学员.但是我使用了...**CompletableFurther**....

##### 共享工具4:Exchanger线程变量交换，使用极少，有点意思.
> 暂时没有用到,所以,,尚未仔细研究.

#### Unsafe类
> Unsafe提供的API大致可分为内存操作、CAS、Class相关、对象操作、线程调度、系 统信息获取、内存屏障、数组操作等几类，下面将对其相关方法和应用场景进行详细介绍。
* 常用的功能.
  * 其中申请内存的操作,是在Netty中使用的.零copy...,就是通过申请堆外内存来操作的.
  * park和unpark,通过查看c++代码发现,park方法一旦发现当前线程有许可证,即刻返回,不再等待.而unpark是先给当前线程设置许可证.
    * 所以,unpark后调用park方法,并不会使线程变为等待状态.
    * 但是如果,先park,那当前线程就会变为等待状态,只能由其他线程(或者时间到了后)来解除等待状态.
![Unfase](../../../Images/programming/java/base/Unfase.png)

#### BlockingQueue阻塞队列
> 使用的是条件队列.
> 条件对接是没有用到node的prev和next
* 阻塞队列的种类
  * ArrayBlockingQueue 数组阻塞队列
  * LinkedBlockingQueue 链表阻塞队列
  * PriorityBlockingQueue 优先级阻塞队列
  * DelayQueque 优先级支持的,基于时间值的调度队列.
* 条件队列重中之重
  * **条件队列最终的Node结点会加入到同步队列(CLH),因为只有这样,才能获取到同步锁(因为阻塞队列使用了RenntrantLock)**

##### ArrayBlockingQueue
* 未完待续,**太难了**,图只是画了一部分,需要再次仔细来看.
  ![BlockingQueue](../../../Images/programming/java/base/BlockingQueue-太难了-未完待续.png)
  
##### DelayQueque
* 延迟队列,其延迟原来是UNSAFE.park(false/true, time)
  * UNSAFE.park(**false**, time); 等待一段**纳秒**时间
  * UNSAFE.park(**true**, time); 等待一段**毫秒**时间
  * UNSAFE.park(false, 0L); 立即进入等待状态,除非有人unpark,否则一直等待.
* 原理是使用的C++编写的定时器,最终调用操作系统的函数库,来实现不同的操作.
* DelayQueue简略流程图.
![DelayQueue](../../../Images/programming/java/base/DelayQueue.png)

#### 线程池的几个方法
* 线程池的5种状态
  1. running
  2. stop 有点不同，前者不会接受新任务，会运行队列中的任务,中断线程(Thread.interrupted())
  3. shutdown 进入stop状态，停止接受新任务，不会运行队列中的任务,中断线程(Thread.interrupted())
  4. termeneed终结
  5. tidying
* 线程池的方法操作.
  1. execute
  2. submit ->  RunnableFuture<T> ftask = newTaskFor(task, result);execute(ftask); 最终也对调用execute
  3. shutdown
  4. shutdownNow
* 线程池重要参数
  * corePoolSize 核心线程池数目
  * 非核心线程池 maximumPoolSize - corePool (线程用完就消亡)
  * BlockingQueue
  * maximumPoolSize 最大线程池数目
  * RejectionExecutionHandler
  * keepAliveTime 等待工作的超时时间,如果当前worker数量超过核心线程数目了,那么最多阻塞keepAliveTime的时间.
  * allowCoreThreadTimeOut 允许核心线程超时.默认是false,如果核心线程闲置的一直存活;如果是true,配合`keepAliveTime`一起使用最大超时等待固定的时间,若没等到则线程消亡.
* 线程池执行过程.
  * 下面是线程池对整个执行过程.不是很复杂,重点是理解Worker整个概念.
  ![ThreadPool](../../../Images/programming/java/base/ThreadPool.png)
##### 定时任务线程池
> 定时任务线程是,是基于DelayQueue实现的.
* 与普通的线程池不同
  * 在addWorker的时候,普通线程池会带一个任务过去,比如addWork(task,true),而定时任务不会,只会addWork(null,true)
  * 在(上图)getTask方法获取任务的时候,是从DelayQueue获取的,DelayQueue添加的时候已经做好了排序.
* 本次暂时不做图,定时任务,基本上是线程池的流程图,加上DelayQueue的综合整理.
* 定时任务，里面使用了一个`堆`的数据结构DelayWorkQueue.


java中多线程的一些知识点梳理
* 可重入：当一个线程进入一个锁的同步代码块的时候，锁的计数器+1，当线程退出同步代码块数量-1.（注意Synchronized和ReentrantLock，都是重入锁）
* 高并发：
  * 使用无状态对象（无实力变量，无其他类中域的引用），这是‘不共享数据保证线程安全’的实例之一。
* 线程封闭
  * 栈封闭，在方法内声明变量
  * ThreadLocal
    * 当调用ThreadLocal.get()方法,会将当前ThreadLocal引用作为正在运行Thread中的ThreadLocalMap的key,在Map的Entry[]中检索value值.简而言之：get方法总是返回当前线程使用set方法设置的最新值。ThreadLocal的值会随着线程的消亡而被垃圾回收，所以在使用线程池的时候（线程不会消亡），总是在end时清除保存的值，总是在begin时set值。
    * 应用：实现应用程序框架的时候被大量使用。
  * 不变性final
* 同步容器：Hashtable，Vector
* 并发容器：ConcurrentHashMap，CopyOnWriteArrayList，BlockingQueue（生成消费模式）
* JVM在启动的时候，创建的所有线程中，除了主线程以为其他都是守护线程。（如垃圾回收器，其他辅助线程）默认情况下，主线程创建的所有线程都是普通线程。
* 线程join,api解释是`Waits for this thread to die`,等待当前线程死亡.
* AQS,抽象队列同步器.