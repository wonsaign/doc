## 网络相关问题
* 只有java才有session,只有request才有session
* 关于浏览器Cookie共享问题(`单点登陆`):
    * 1,跨域,使用nginx反向代理,并缓存cookie等相关,做到`欺骗`浏览器;或者自定义实现cookie
    * 2,不跨域,根据cookie特性:二级域名[^1]可以共享cookie,需要设置cookie的四个可选属性`path`,`domain`,`安全属性`,`expires`中的`domain`属性为".abc.com"(任意二级域名)
* Http请求,在java中实际上是Socket[^2]编程,使用socket可以从网络中读取数据.
* Tomcat工作原理
    * HttpConnector,连接器:负责链接指定端口(如8080)的http请求,并创建HttpProcessor
    * HttpProcessor,负责创建HttpRequest实例,并填充为成员变量,使用parseRequest()方法和 xxx 将HTTP请求中的行和头信息,解析并填充到HttpRequest中(但是不会解析字符串),具体是调用`process()->创建HttpRequest和HttpResponse;解析第一行内容和请求头并填充到HttpRequest`
    * HttpRequest,

[^1]: 如:二级域名(www.baidu.com或者tieba.baidu.com); 而一级域名是baidu.com;
[^2]: 套接字（socket）是通信的基石，是支持TCP/IP协议的网络通信的基本操作单元