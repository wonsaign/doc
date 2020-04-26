#### Java IO模型

##### BIO
> 同步阻塞IO

![经典BIO](../../Images/programming/java/BIO实现流程图.png)

##### NIO
> 同步非阻塞IO,一个线程可以处理多个事件,大大提高了线程利用率,减少了线程创建的成本.


![经典NIO](../../Images/programming/java/经典nio实现流程.png)


##### AIO(NIO2)
> 异步非阻塞IO,是基于NIO模型进行封装的.