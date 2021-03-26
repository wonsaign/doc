### zabbix


#### 下载
> 本文安装的5.0版本的长期支持版，安装方式有多种，有安装包二进制安装，有docker容器安装
* Server安装
  1. https://www.zabbix.com/cn/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=apache
  2. 安装版本5.0LTS[^1]
  3. 重启server-> systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
  4. 配置文件位置：/etc/zabbix/zabbix_agentd.conf
* Agent安装 
  1. rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-agent-5.0.9-1.el7.x86_64.rpm
  2. yum install zabbix-agent
  3. systemctl enable zabbix-agent
  4. systemctl start zabbix-agent
  5. ps aux |grep zabbix_agentd
  6. vim /etc/zabbix/zabbix_agentd.conf
  ```
  Server
  ServerActive 
  ```
  7. systemctl restart zabbix-agent
  8. **check**-> 服务端安装zabbix_get，zabbix_get -s **代理机IP** -p 10050 -k "system.hostname" 获取
* JMX安装，安装在server端
  1. yum -y install zabbix-java-gateway
  2. vim /etc/zabbix/zabbix_java_gateway.conf  
  ```
    LISTEN_IP="0.0.0.0"#监听本机所有ip
    LISTEN_PORT=10052#在10052端口提供服务
    PID_FILE="/var/run/zabbix/zabbix_java.pid"
    START_POLLERS=5
  ```  
  3. systemctl start zabbix-java-gateway 服务启动 
  4. vim /etc/zabbix/abbix_server.conf
  ```
    JavaGateway=127.0.0.1#JavaGateway所在服务器的IP
    JavaGatewayPort=10052#JavaGateway的默认端口
    StartJavaPollers=5#JVM进行监控轮询实例数，默认是0
  ```
  5. systemctl restart zabbix-java-gateway
  6. lsof -i:10052 查看默认的端口是否启动 


#### Q&S
* Q：Check access restrictions in Zabbix agent configuration
  * A 没有配置代理机
* Q: Connection timed out: service:jmx:rmi:///jndi/rmi://xxx.xxx.xx:10011/jmxrmi
  * A 添加配置参数-Dcom.sun.management.jmxremote.rmi.port=10052
* non-JRMP server at remote endpoint: service:jmx:rmi:///jndi/rmi://192.168.29.31:12345/jmxrmi
* Q: zabbix乱码解决
  * A: yum -y install wqy-microhei-fonts
  * \cp /usr/share/fonts/wqy-microhei/wqy-microhei.ttc /usr/share/fonts/dejavu/DejaVuSans.ttf 

[^1]: 长期支持版本(Long Term Support)