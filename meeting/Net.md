## 网络相关问题
* 只有java才有session
* 关于浏览器Cookie共享问题(`单点登陆`):
    * 1,跨域,使用nginx反向代理,并缓存cookie等相关,做到`欺骗`浏览器;或者自定义实现cookie
    * 2,不跨域,根据cookie特性:二级域名[^1]可以共享cookie,需要设置cookie的四个可选属性`path`,`domain`,`安全属性`,`expires`中的`domain`属性为".abc.com"(任意二级域名)

[^1]: 如:二级域名(www.baidu.com或者tieba.baidu.com); 而一级域名是baidu.com;