## Multi Thread
---
java中多线程的一些知识点梳理

* 可重入：当一个线程进入一个锁的同步代码块的时候，锁的计数器+1，当线程退出同步代码块数量-1.（注意Synchronized和ReentrantLock，都是重入锁）
* 高并发：
  * 使用无状态对象（无实力变量，无其他类中域的引用），这是‘不共享数据保证线程安全’的实例之一。
* 线程封闭
  * 栈封闭，在方法内声明变量
  * ThreadLocal
    * 当调用ThreadLocal.get()方法,会将当前ThreadLocal引用作为正在运行Thread中的ThreadLocalMap的key,在Map的Entry[]中检索value值.简而言之：get方法总是返回当前线程使用set方法设置的最新值。ThreadLocal的值会随着线程的消亡而被垃圾回收，所以在使用线程池的时候（线程不会消亡），总是在end时清除保存的值，总是在begin时set值。
    * 应用：实现应用程序框架的时候被大量使用。
  * 不变性