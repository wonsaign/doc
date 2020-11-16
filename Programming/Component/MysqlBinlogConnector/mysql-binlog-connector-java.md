### mysql-binlog-connector-java

#### 相关sql
```
maxwell设置
CREATE USER 'maxwell'@'%' IDENTIFIED BY '123456';
GRANT ALL ON maxwell.* TO 'maxwell'@'%';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE on *.* to 'maxwell'@'%'; 

binlog
// 正在同步的binlog
show master status;
// 展示binlog的格式
SHOW BINLOG EVENTS
   [IN 'log_name']
   [FROM pos]
   [LIMIT [offset,] row_count]
example：
    show binlog events in 'mysql-bin.000009' FROM 779 ;
    show binlog events in 'mysql-bin.000009' FROM 779 limit 5; // pos为779的位置取5条
    show binlog events in 'mysql-bin.000009' FROM 779 limit 2,5;// pos为779的位置偏移两条后取5条
// binlog列表
show binary logs;

```

#### 客户端定制
* 设计思路是这样的
  * show binlog events in 'mysql-bin.000009' FROM 779 ;通过客户端开启dump请求，不是从show master status的位置开始