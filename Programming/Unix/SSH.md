### SSH工具

#### SSH命令参数
* -1：强制使用ssh协议版本1
* -2：强制使用ssh协议版本2
* -4：强制使用IPv4地址
* -6：强制使用IPv6地址
* -A：开启认证代理连接转发功能
* -a：关闭认证代理连接转发功能
* -b：使用本机指定地址作为对应连接的源ip地址
* -C：请求压缩所有数据
* -c：选择所加密的密码型式 （blowfish|3des 预设是3des）
* -e：设定跳脱字符
* -F：指定ssh指令的配置文件
* -f：后台执行ssh指令
* -g：允许远程主机连接主机的转发端口
* -i：指定身份文件（预设是在使用者的家目录 中的 .ssh/* identity）
* -l：指定连接远程服务器登录用户名
* -N：不执行远程指令
* -n：重定向stdin 到 /dev/null
* -o：指定配置选项
* -p：指定远程服务器上的端口（默认22）
* -P：使用非特定的 port 去对外联机（注意这个选项会关掉 * RhostsAuthentication 和 RhostsRSAAuthentication）
* -q：静默模式
* -T：禁止分配伪终端
* -t：强制配置 pseudo-tty
* -v：打印更详细信息
* -X：开启X11转发功能
* -x：关闭X11转发功能
* -y：开启信任X11转发功能
* -L listen-port:host:port 指派本地的 port 到达端机器地* 址上的 port
  * 建立本地SSH隧道(本地客户端建立监听端口)
  * 将本地机(客户机)的某个端口转发到远端指定机器的指定端口.
* -R listen-port:host:port 指派远程上的 port 到本地地址* 上的 port
  * 建立远程SSH隧道(隧道服务端建立监听端口)
  * 将远程主机(服务器)的某个端口转发到本地端指定机器的指定端口.
* -D port 指定一个本地机器 “动态的“ 应用程序端口转发.

#### SSH 例
1. ssh host chaining
```shell
# 直接登录到dc95
ssh -A -t -l wangsai gw \
> ssh -A -t -l dc dc95

不换行写法：ssh -A -t -l wangsai gw  ssh -A -t -l dc dc95
```
2. ssh port forwarding
```shell
# 将远程的192.168.9.201机器3306端口，映射到本机
# 如果是在本机登录，需要登录到192.168.9.201，并需要远程机器的密码，并且登录
ssh -L [LOCAL_IP:]LOCAL_PORT:DESTINATION:DESTINATION_PORT [USER@]SSH_SERVER
e.x.: ssh -v -L 3306:127.0.0.1:3306 root@192.168.9.201

# 将远程的192.168.9.201机器3306端口，映射到本机
# 如果是在本机登录，需要本机的ssh密钥到密码，不会登录
ssh -R [REMOTE:]REMOTE_PORT:DESTINATION:DESTINATION_PORT [USER@]SSH_SERVER
e.x.: ssh -v -R 3306:192.168.9.201:3306 127.0.0.1
```
3. screen 执行 ssh host chaining + ssh port forwarding
```shell
# 思路是：一层一层的穿越
sudo ssh -i id_rsa -p 30228  -ftR 5432:114.112.99.78:5432 114.112.99.78 ssh -NR 5432:114.112.99.78:5432 127.0.0.1

给我整不会了

```