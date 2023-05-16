### TiDB技术调研

#### 应用场景

* 对数据一致性及高可靠、系统高可用、可扩展性、容灾要求较高的金融行业属性的场景

> 众所周知，金融行业对数据一致性及高可靠、系统高可用、可扩展性、容灾要求较高。传统的解决方案是同城两个机房提供服务、异地一个机房提供数据容灾能力但不提供服务，此解决方案存在以下缺点：资源利用率低、维护成本高、RTO (Recovery Time Objective) 及 RPO (Recovery Point Objective) 无法真实达到企业所期望的值。TiDB 采用多副本 + Multi-Raft 协议的方式将数据调度到不同的机房、机架、机器，当部分机器出现故障时系统可自动进行切换，确保系统的 RTO <= 30s 及 RPO = 0 。

* 对存储容量、可扩展性、并发要求较高的海量数据及**高并发**的 OLTP 场景

> 随着业务的高速发展，数据呈现爆炸性的增长，传统的单机数据库无法满足因数据爆炸性的增长对数据库的容量要求，可行方案是采用分库分表的中间件产品或者 NewSQL 数据库替代、采用高端的存储设备等，其中性价比最大的是 NewSQL 数据库，例如：TiDB。TiDB 采用计算、存储分离的架构，可对计算、存储分别进行扩容和缩容，计算最大支持 512 节点，每个节点最大支持 1000 并发，集群容量最大支持 PB 级别。

* Real-time HTAP 场景

> 随着 5G、物联网、人工智能的高速发展，企业所生产的数据会越来越多，其规模可能达到数百 TB 甚至 PB 级别，传统的解决方案是通过 OLTP 型数据库处理在线联机交易业务，通过 ETL 工具将数据同步到 OLAP 型数据库进行数据分析，这种处理方案存在存储成本高、实时性差等多方面的问题。TiDB 在 4.0 版本中引入列存储引擎 TiFlash 结合行存储引擎 TiKV 构建真正的 HTAP 数据库，在增加少量存储成本的情况下，可以同一个系统中做联机交易处理、实时数据分析，极大地节省企业的成本。

* 数据汇聚、二次加工处理的场景

> 当前绝大部分企业的业务数据都分散在不同的系统中，没有一个统一的汇总，随着业务的发展，企业的决策层需要了解整个公司的业务状况以便及时做出决策，故需要将分散在各个系统的数据汇聚在同一个系统并进行二次加工处理生成 T+0 或 T+1 的报表。传统常见的解决方案是采用 ETL + Hadoop 来完成，但 Hadoop 体系太复杂，运维、存储成本太高无法满足用户的需求。与 Hadoop 相比，TiDB 就简单得多，业务通过 ETL 工具或者 TiDB 的同步工具将数据同步到 TiDB，在 TiDB 中可通过 SQL 直接生成报表。

#### 基本功能
本文详细介绍 TiDB 具备的基本功能。

##### 数据类型
数值类型：BIT、BOOL|BOOLEAN、SMALLINT、MEDIUMINT、INT|INTEGER、BIGINT、FLOAT、DOUBLE、DECIMAL。

日期和时间类型：DATE、TIME、DATETIME、TIMESTAMP、YEAR。

字符串类型：CHAR、VARCHAR、TEXT、TINYTEXT、MEDIUMTEXT、LONGTEXT、BINARY、VARBINARY、BLOB、TINYBLOB、MEDIUMBLOB、LONGBLOB、ENUM、SET。

JSON 类型。

##### 运算符
算术运算符、位运算符、比较运算符、逻辑运算符、日期和时间运算符等。
字符集及排序规则
字符集：UTF8、UTF8MB4、BINARY、ASCII、LATIN1。

排序规则：UTF8MB4_GENERAL_CI、UTF8MB4_GENERAL_BIN、UTF8_GENERAL_CI、UTF8_GENERAL_BIN、BINARY。

##### 函数
控制流函数、字符串函数、日期和时间函数、位函数、数据类型转换函数、数据加解密函数、压缩和解压函数、信息函数、JSON 函数、聚合函数、窗口函数等。
##### SQL 语句
完全支持标准的 Data Definition Language (DDL) 语句，例如：CREATE、DROP、ALTER、RENAME、TRUNCATE 等。

完全支持标准的 Data Manipulation Language (DML) 语句，例如：INSERT、REPLACE、SELECT、Subqueries、UPDATE、LOAD DATA 等。

完全支持标准的 Transactional and Locking 语句，例如：START TRANSACTION、COMMIT、ROLLBACK、SET TRANSACTION 等。

完全支持标准的 Database Administration 语句，例如：SHOW、SET 等。

完全支持标准的 Utility 语句，例如：DESCRIBE、EXPLAIN、USE 等。

完全支持 SQL GROUP BY 和 ORDER BY 子语句。

完全支持标准 SQL 语法的 LEFT OUTER JOIN 和 RIGHT OUTER JOIN。

完全支持标准 SQL 要求的表和列别名。

##### 分区表
支持 Range 分区。

支持 Hash 分区。

##### 视图
支持普通视图。
##### 约束
支持非空约束。

支持主键约束。

支持唯一约束。

##### 安全
支持基于 RBAC (role-based access control) 的权限管理。

支持密码管理。

支持通信、数据加密。

支持 IP 白名单。

支持审计功能。

##### 工具
支持快速备份功能。

支持通过工具从 MySQL 迁移数据到 TiDB。

支持通过工具部署、运维 TiDB。



### 官方文档
1. 快速上手 https://docs.pingcap.com/zh/tidb/stable/quick-start-with-tidb