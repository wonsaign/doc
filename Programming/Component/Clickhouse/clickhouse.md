### Clickhouse 学习笔记
> 列式数据库
* OLAP场景特征
  * 大多数是读请求
  * 数据总是以相当大的批(> 1000 rows)进行写入
  * 不修改已添加的数据
  * 每次查询都从数据库中读取大量的行，但是同时又仅需要少量的列
  * 宽表，即每个表包含着大量的列
  * 较少的查询(通常每台服务器每秒数百个查询或更少)
  * 对于简单查询，允许延迟大约50毫秒
  * 列中的数据相对较小： 数字和短字符串(例如，每个URL 60个字节)
  * 处理单个查询时需要高吞吐量（每个服务器每秒高达数十亿行）
  * 事务不是必须的
  * 对数据一致性要求低
  * 每一个查询除了一个大表外都很小
  * 查询结果明显小于源数据，换句话说，数据被过滤或聚合后能够被盛放在单台服务器的内存中
* 列式数据库为何更适合OLAP特征
  * 输入/输出（IO降低）
    * 针对分析类查询，通常只需要读取表的一小部分列。在列式数据库中你可以只读取你需要的数据。例如，如果只需要读取100列中的5列，这将帮助你最少减少20倍的I/O消耗。
    * 由于数据总是打包成批量读取的，所以压缩是非常容易的。同时数据按列分别存储这也更容易压缩（都是同一类型的数值）。这进一步降低了I/O的体积。
    * 由于I/O的降低，这将帮助更多的数据被系统缓存
  * CPU
    * 由于执行一个查询需要处理大量的行，因此在整个向量上执行所有操作将比在每一行上执行所有操作更加高效
* ClickHouse的特性
  * 真正的列式数据库管理系统
    > 在一个真正的列式数据库管理系统中，除了数据本身外不应该存在其他额外的数据,这意味着为了避免在值旁边存储它们的长度«number»，比如【varchar(256)】,这种方式无疑浪费了很多空间。影响了压缩效率。
  * 磁盘
    >lickHouse被设计用于工作在传统磁盘上的系统，它提供每GB更低的存储成本，但如果有可以使用SSD和内存，它也会合理的利用这些资源。
* Clickhouse具备以下特点
```
Ø  1.真正的面向列的DBMS
Ø  2.数据高效压缩
Ø  3.磁盘存储的数据
Ø  4.多核并行处理
Ø  5.在多个服务器上分布式处理
Ø  6.SQL语法支持
Ø  7.向量化引擎
Ø  8.实时数据更新
Ø  9.索引
Ø  10.适合在线查询
Ø  11.支持近似预估计算
Ø  12.支持嵌套的数据结构 Nested
Ø  13.支持数组作为数据类型 Array Tuple(t1, T2, …)
Ø  14.支持限制查询复杂性以及配额
Ø  15.复制数据复制和对数据完整性的支持
```


#### 优缺点
##### 优点
* 为了高效的使用CPU，数据不仅仅按列存储，同时还按向量进行处理；
* 数据压缩空间大，减少IO；处理单查询高吞吐量每台服务器每秒最多数十亿行；
* 索引非B树结构，不需要满足最左原则；只要过滤条件在索引列中包含即可；即使在使用的数据不在索引中，由于各种并行处理机制ClickHouse全表扫描的速度也很快；
* 写入速度非常快，50-200M/s，对于大量的数据更新非常适用。
##### 缺点
* 不支持事务，不支持真正的删除/更新，主键可以重复插入。
* 不支持高并发，官方建议qps为100，可以通过修改配置文件增加连接数，但是在服务器足够好的情况下；目前通过修改max_concurrent_queries来设置，但是实际使用发现并没有生效
* SQL满足日常使用80%以上的语法，join写法比较特殊；最新版已支持类似SQL的join，但性能不好；
* 尽量做1000条以上批量的写入，避免逐行insert或小批量的insert，update，delete操作，因为ClickHouse底层会不断的做异步的数据合并，会影响查询性能，这个在做实时数据写入的时候要尽量避开；
* Clickhouse快是因为采用了并行处理机制，即使一个查询，也会用服务器一半的CPU去执行，所以ClickHouse不能支持高并发的使用场景，默认单查询使用CPU核数为服务器核数的一半，安装时会自动识别服务器核数，可以通过配置文件修改该参数。

#### 单机配置
* Docker
* Linux

#### Engine引擎
* MergeTree
  * (Replicated)MergeTree
  * 重要概念
  > block（分区，通过使用partion by 自定义分区,但是每次插入会分为多个数据块。会自动合并,手动合并是OPTIMIZE）
  > 一般不需要人为操作，自动的进行合并。No control. No interval.You should not rely on a merge process. It has own complicated algorithm to balance number of parts. Merge has no goal to do final merge -- to make 1 part because it's not efficient and wasting of disk I/O and CPU.
  ```
  该引擎为最简单的引擎，存储最原始数据不做任何的预计算
  任何在该引擎上的select语句都是在原始数据上进行操作的，常规场景使用最为广泛，其他引擎都是该引擎的一个变种。
  ```
  * (Replicated)SummingMergeTree
  ```
  该引擎拥有“预计算(加法)”的功能。
  实现原理：在merge阶段把数据加起来(对于需要加的列需要在建表的时候进行指定)，对于不可加的列，会取一个最先出现的值。
  ```
  * (Replicated)ReplacingMergeTree
  ```
  该引擎拥有“处理重复数据”的功能。
  使用场景：“最新值”，“实时数据”。
  ```
  * (Replicated)AggregatingMergeTree
  ```
  该引擎拥有“预聚合”的功能。
  使用场景：配合”物化视图”来一起使用，拥有毫秒级计算UV和PV的能力。
  ```
  * (Replicated)CollapsingMergeTree
  ```
  该引擎和ReplacingMergeTree的功能有点类似，就是通过一个sign位去除重复数据的。
  需要注意的是，上述所有拥有"预聚合"能力的引擎都在"Merge"过程中实现的，所以在表上进行查询的时候SQL是需要进行特殊处理的。
  如SummingMergeTree引擎需要自己sum(), ReplacingMergeTree引擎需要使用时间+版本进行order by + limit来取到最新的值，由于数据做了预处理，数据量已经减少了很多，所以查询速度相对会快非常多。
  ```
#### 导入数据表
* mysql 
  * CREATE TABLE bus_order ENGINE = MergeTree  ORDER BY (OrderNo) AS SELECT * FROM mysql('103.61.153.18:3306', 'dp_ordm4', 'bus_order', 'pengbo', '123456');

#### Jdbc
* [官方驱动](https://github.com/ClickHouse/clickhouse-jdbc)
* java的jdbc代码就不再详细赘述

#### 配置
[配置文件](setting.md)

#### Distributed/Replicated集群分片
* docker集群搭建步骤
  1. docker-compose.yml
    ```
    version: '3'

    services:
    zk:
        container_name: zk
        image: zookeeper:latest
        ports:
        - "2181:2181"
        - "3888:3888"
        - "2888:2888"

    ch1:
        container_name: ch1
        image: yandex/clickhouse-server:latest
        links:
        #- ch2
        #- ch3
        - zk
        ports:
        # http_port
        - "8123:8123"
        # tcp_port
        - "9100:9000"
        # https_port
        #- "8443:8443"
        # tcp_port_secure
        #- "9440:9440"
        # interserver_http_port
        - "9109:9009"
        # mysql_port
        - "9104:9004"
        volumes:
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/etc:/etc/clickhouse-server"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch1/etc/metrika.xml:/etc/clickhouse-server/metrika.xml"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch1/data:/var/lib/clickhouse"
        ulimits:
        nproc: 65535
        nofile:
            soft: 262144
            hard: 262144
        expose:
        - "9000"

    ch2:
        container_name: ch2
        image: yandex/clickhouse-server:latest
        links:
        - zk
        ports:
        # http_port
        - "8223:8123"
        # tcp_port
        - "9200:9000"
        # https_port
        #- "8443:8443"
        # tcp_port_secure
        #- "9440:9440"
        # interserver_http_port
        - "9209:9009"
        # mysql_port
        - "9204:9004"
        volumes:
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/etc:/etc/clickhouse-server"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch2/etc/metrika.xml:/etc/clickhouse-server/metrika.xml"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch2/data:/var/lib/clickhouse"
        ulimits:
        nproc: 65535
        nofile:
            soft: 262144
            hard: 262144
        expose:
        - "9000"

    ch3:
        container_name: ch3
        image: yandex/clickhouse-server:latest
        links:
        - zk
        ports:
        # http_port
        - "8323:8123"
        # tcp_port
        - "9300:9000"
        # https_port
        #- "8443:8443"
        # tcp_port_secure
        #- "9440:9440"
        # interserver_http_port
        - "9309:9009"
        # mysql_port
        - "9304:9004"
        volumes:
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/etc:/etc/clickhouse-server"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch3/etc/metrika.xml:/etc/clickhouse-server/metrika.xml"
        - "/Users/wangsai/IWork/Coding/Projects/docker/clickhouse/ch3/data:/var/lib/clickhouse"
        ulimits:
        nproc: 65535
        nofile:
            soft: 262144
            hard: 262144
        expose:
        - "9000"

    ```
    2. 新增集群配置**metrika.xml**，[官网地址](https://clickhouse.tech/docs/en/engines/table-engines/special/distributed/)
    ```
    <yandex>
        <!-- 集群配置 -->
        <clickhouse_remote_servers>
            <!-- 集群名称 The cluster name in the server’s config file.-->
            <test_cluster>
                <!-- 数据分片1  -->
                <!-- Optional. Shard weight when writing data. Default: 1. 权重 -->
                <!-- <weight>1</weight> -->
                <shard>
                    <!-- Optional. Whether to write data to just one of the replicas. Default: false (write data to all replicas). -->
                    <!-- 只将数据写入一个分片， false写入其他分片 -->
                    <internal_replication>false</internal_replication>
                    <replica>
                        <!-- Optional. Priority of the replica for load balancing (see also load_balancing setting). Default: 1 (less value has more priority). -->
                        <priority>1</priority>
                        <host>ch1</host>
                        <port>9000</port>
                        <user>default</user>
                        <password></password>
                    </replica>
                </shard>

                <!-- 数据分片2  -->
                <shard>
                    <internal_replication>false</internal_replication>
                    <replica>
                        <host>ch2</host>
                        <port>9000</port>
                        <user>default</user>
                        <password></password>
                    </replica>
                </shard>

                <!-- 数据分片3  -->
                <shard>
                    <internal_replication>false</internal_replication>
                    <replica>
                        <host>ch3</host>
                        <port>9000</port>
                        <user>default</user>
                        <password></password>
                    </replica>
                </shard>

            </test_cluster>
        </clickhouse_remote_servers>

        <!-- 本节点副本名称（这里无用） -->
        <macros>
            <replica>ch3</replica>
        </macros>

        <!-- 监听网络（貌似重复） -->
        <networks>
        <ip>::/0</ip>
        </networks>

        <!-- ZK 配置 -->
        <zookeeper-servers>
            <node index="1">
                <host>ch1</host>
                <port>2181</port>
            </node>
            <node index="2">
                <host>ch2</host>
                <port>2181</port>
            </node>
            <node index="3">
                <host>ch3</host>
                <port>2181</port>
            </node>
        </zookeeper-servers>

        <!-- 数据压缩算法  -->
        <clickhouse_compression>
        <case>
        <min_part_size>10000000000</min_part_size>
        <min_part_size_ratio>0.01</min_part_size_ratio>
        <method>lz4</method>
        </case>
        </clickhouse_compression>

    </yandex>
    ```

entrypoint.sh....，docker启动会加载这个脚本启动对应的容器里的镜像

#### clickhouse优化使用
1. 如果对一张基本表经常进行group sum操作，可以创建对应对物化视图，**预处理**
2. 可以考虑通过sqlserver -> mysql -> MaterializeMySQL到clickhouse（是否对表更新）？
3. 当多表联查时，查询的数据仅从其中一张表出时，可考虑使用IN操作而不是JOIN。
4. 多表Join时要满足小表在右的原则，右表关联时被加载到内存中与左表进行比较。
5. 将一些需要关联分析的业务创建成字典表进行join操作，前提是字典表不易太大，因为字典表会常驻内存
6. 使用prewhere替代where关键字；当查询列明显多于筛选列时使用prewhere可十倍提升查询性能  prewhere 会自动优化执行过滤阶段的数据读取方式，降低io操作
7. 数据量太大时应避免使用select * 操作，查询的性能会与查询的字段大小和数量成线性变换；字段越少，消耗的io资源就越少，性能就会越高。
8. 千万以上数据集进行order by查询时需要搭配where条件和limit语句一起使用
9. 使用 uniqCombined 替代 distinct 性能可提升10倍以上，uniqCombined 底层采用类似HyperLogLog算法实现，如能接收2%左右的数据误差，可直接使用这种去重方式提升查询性能。

#### Issues
* 读写分离 Separator the resource for Insert and Query，Keep the insert ability.[#3575](https://github.com/ClickHouse/ClickHouse/issues/3575)
  * answer
  ```
    It's easy to add new settings
    max_concurrent_insert_queries
    max_concurrent_select_queries
    Up for grabs.
  ```
* 不支持唯一主键，可以使用ReplacingMergeTree，clickhouse会在后台不定时的进行merge操作，对重复的主键进行合并。

#### 使用命令
* clickhouse-client -h 172.17.186.106 -u default --password=w123$