####动态链接
> 下面是使用javap -c -v -l xxx.class所展示出来的部门class字节码

* 文件中的`#`是代表了常量池的符号.
* `Constant pool`常量池
```
Classfile 
  Last modified 2020年4月20日; size 623 bytes
  SHA-256 checksum cff2fc6044fea109487bfe1739fff9178536ee320ef2e1706d95878d9e47611d
  Compiled from "Calculate.java"
public class com.learn.java.lang.wangs.base.math.Calculate
  minor version: 0
  major version: 55
  flags: (0x0021) ACC_PUBLIC, ACC_SUPER
  this_class: #7                          // com/learn/java/lang/wangs/base/math/Calculate
  super_class: #2                         // java/lang/Object
  interfaces: 0, fields: 0, methods: 3, attributes: 1
Constant pool:
   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
   #2 = Class              #4             // java/lang/Object
   #3 = NameAndType        #5:#6          // "<init>":()V
   #4 = Utf8               java/lang/Object
   #5 = Utf8               <init>
   #6 = Utf8               ()V
   #7 = Class              #8             // com/learn/java/lang/wangs/base/math/Calculate
   #8 = Utf8               com/learn/java/lang/wangs/base/math/Calculate
   #9 = Methodref          #7.#3          // com/learn/java/lang/wangs/base/math/Calculate."<init>":()V
  #10 = Methodref          #7.#11         // com/learn/java/lang/wangs/base/math/Calculate.onePlusTwo:()I
  #11 = NameAndType        #12:#13        // onePlusTwo:()I
  #12 = Utf8               onePlusTwo
  #13 = Utf8               ()I
  #14 = Utf8               Code
  #15 = Utf8               LineNumberTable
  #16 = Utf8               LocalVariableTable
  #17 = Utf8               this
  #18 = Utf8               Lcom/learn/java/lang/wangs/base/math/Calculate;
  #19 = Utf8               a
  #20 = Utf8               I
  #21 = Utf8               b
  #22 = Utf8               main
  #23 = Utf8               ([Ljava/lang/String;)V
  #24 = Utf8               args
  #25 = Utf8               [Ljava/lang/String;
  #26 = Utf8               calculate
  #27 = Utf8               SourceFile
  #28 = Utf8               Calculate.java
{
  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: (0x0009) ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=2, args_size=1
         0: new           #7 (符号引用)                 // class com/learn/java/lang/wangs/base/math/Calculate
         3: dup
         4: invokespecial #9 (符号引用)                 // Method "<init>":()V
         7: astore_1
         8: aload_1
         9: invokevirtual #10 (符号引用)               // Method onePlusTwo:()I
        12: pop
        13: return
      LineNumberTable:
        line 13: 0
        line 14: 8
        line 15: 13
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0      14     0  args   [Ljava/lang/String;
            8       6     1 calculate   Lcom/learn/java/lang/wangs/base/math/Calculate;
}

举一个例子:
invokespecial #9 (符号引用)
那么对应的链接最终是 #9->#7.#3->#8.#3->#8,#5:#6->com/learn/java/lang/wangs/base/math/.<init>:()V
可以看出实际上是调用的java中隐藏的<init>函数来完成初始化.
```