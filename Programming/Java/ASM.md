### ASM技术
#### 什么是ASM
>ASM是一个Java字节码操控框架。它能被用来动态生成类或者增强既有类的功能
* ASM可以直接产生二进制class文件，也可以在类被加载入Java虚拟机之前动态改变类行为
    ```
        Java class被存储在严格格式定义的`.class`文件里，这些类文件拥有足够的元数据来解析类中的所有元素：类名称、方法、属性以及 Java 字节码（指令）
        ASM从类文件中读入信息后，能够改变类行为，分析类信息，甚至能够根据用户要求生成新类。
        与BCEL和SERL不同，ASM提供了更为现代的编程模型。
        对于ASM来说，Java class被描述为一棵树；使用 “Visitor” 模式遍历整个二进制结构；事件驱动的处理方式使得用户只需要关注于对其编程有意义的部分，而不必了解Java 类文件格式的所有细节.
        ASM框架提供了默认的 “response taker”处理这一切。
    ```
#### 为什么要动态生成Java类
> 动态生成Java类与AOP密切相关的
* AOP的初衷在于软件设计世界中存在这么一类代码，零散而又耦合.
  ```
    零散是由于一些公有的功能（诸如著名的log例子）分散在所有模块之中；同时改变 log 功能又会影响到所有的模块。
    出现这样的缺陷，很大程度上是由于传统的面向对象编程注重以继承关系为代表的“纵向”关系，而对于拥有相同功能或者说方面（Aspect）的模块之间的“横向”关系不能很好地表达。
    ---
    例如，目前有一个既有的银行管理系统，包括 Bank、Customer、Account、Invoice 等对象，现在要加入一个安全检查模块，对已有类的所有操作之前都必须进行一次安全检查。
    然而 Bank、Customer、Account、Invoice 是代表不同的事务，派生自不同的父类，很难在高层上加入关于 Security Checker 的共有功能。
    对于没有多继承的Java来说，更是如此。传统的解决方案是使用Decorator模式，它可以在一定程度上改善耦合，而功能仍旧是分散的:
        —— 每个需要 Security Checker 的类都必须要派生一个 Decorator
        —— 每个需要 Security Checker 的方法都要被包装（wrap）
  ```
* 下面我们以 Account类为例看一下 Decorator：
    ```
    public class SecurityChecker { 
        public static void checkSecurity() { 
            System.out.println("SecurityChecker.checkSecurity ..."); 
            //TODO real security check 
        }  
    }
    ```
    另一个是 Account类：
    ```
    public class Account { 
        public void operation() { 
            System.out.println("operation..."); 
            //TODO real operation 
        } 
    }
    ```
    若想对 operation加入对 SecurityCheck.checkSecurity()调用，标准的 Decorator 需要先定义一个 Account类的接口
    ```
    public interface Account { 
        void operation(); 
    }
    ```
    然后把原来的 Account类定义为一个实现类：
    ```
    public class AccountImpl extends Account{ 
        public void operation() { 
            System.out.println("operation..."); 
            //TODO real operation 
        } 
    }
    ```
    定义一个 Account类的 Decorator，并包装 operation方法：
    ```
    public class AccountWithSecurityCheck implements Account {     
        private  Account account; 
        public AccountWithSecurityCheck (Account account) { 
            this.account = account; 
        } 
        public void operation() { 
            SecurityChecker.checkSecurity(); 
            account.operation(); 
        } 
    }
    ```
    在这个简单的例子里，改造一个类的一个方法还好，如果是变动整个模块，Decorator 很快就会演化成另一个噩梦。动态改变 Java 类就是要解决 AOP 的问题，提供一种得到系统支持的可编程的方法，自动化地生成或者增强 Java 代码。这种技术已经广泛应用于最新的 Java 框架内，如 Hibernate，Spring 等。