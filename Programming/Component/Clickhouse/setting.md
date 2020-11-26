## 配置参数
> 了解了各个参数的目的是更好进行配置和使用资源的限制，关于参数的详细说明可以看官方文档：Server settings、Settings

### Server settings：在config.xml里设置
1. builtin_dictionaries_reload_interval：重新加载内置词典的时间间隔（以秒为单位），默认3600。可以在不重新启动服务器的情况下“即时”修改词典。
```
<builtin_dictionaries_reload_interval>3600</builtin_dictionaries_reload_interval>
```
2. compression：MergeTree引擎表的数据压缩设置。配置模板如：
```
<compression incl="clickhouse_compression">  --指定incl
    <case>
        <min_part_size>10000000000</min_part_size> --数据部分的最小大小
        <min_part_size_ratio>0.01</min_part_size_ratio> --数据部分大小与表大小的比率
        <method>zstd</method> --压缩算法，zstd和lz4
    </case>
</compression>
可以配置多个<case>。如果数据部分与条件集匹配，使用指定的压缩方法；如果数据部分匹配多个条件集，将使用第一个匹配的条件集；如果数据部分不满足任何条件，则使用lz4压缩。
```
3. default_database：默认数据库。
```
<default_database>default</default_database>
```
4. default_profile：默认设置配置文件，在参数user_config中指定。
```
<default_profile>default</default_profile>
```
5. dictionaries_config：外部词典的配置文件的路径，在config配置文件中指定。路径可以包含通配符*和？的绝对或则相对路径。
```
<dictionaries_config>*_dictionary.xml</dictionaries_config>
```
6. dictionaries_lazy_load：延迟加载词典，默认false。
```
<dictionaries_lazy_load>true</dictionaries_lazy_load>
true：在首次使用时创建每个字典。 如果字典创建失败，则正在使用字典的函数将引发异常。
false：在服务器启动时将创建所有字典，如果有错误，则服务器将关闭。
```
7. format_schema_path：包含输入格式文件（例如CapnProto格式的方案）的目录路径。
```
<format_schema_path> format_schemas / </ format_schema_path>
```
8. graphite：将数据发送到Graphite，它是一款企业级监控。 
```
<graphite>
    <host>localhost</host>  -- Graphite服务器
    <port>42000</port>   -- Graphite服务器上的端口
    <timeout>0.1</timeout> -- 发送超时时间，以秒为单位
    <interval>60</interval>  -- 发送间隔，以秒为单位
    <root_path>one_min</root_path> -- 密钥的前缀
    <metrics>true</metrics>  -- 从system.metrics表发送数据
    <events>true</events>  -- 从system.events表发送在该时间段内累积的增量数据
    <events_cumulative>false</events_cumulative> -- 从system.events表发送累积数据
    <asynchronous_metrics>true</asynchronous_metrics> -- 从system.asynchronous_metrics表发送数据
</graphite>
可以配置多个<graphite>子句。例如，您可以使用它以不同的时间间隔发送不同的数据。后期监控会单独写篇文章介绍，目前暂时进行说明。
```
9. graphite_rollup：数据汇总设置
```
<graphite_rollup_example> 
    <default>
        <function>max</function>
        <retention>
            <age>0</age>
            <precision>60</precision>
        </retention>
        <retention>
            <age>3600</age>
            <precision>300</precision>
        </retention>
        <retention>
            <age>86400</age>
            <precision>3600</precision>
        </retention>
    </default>
</graphite_rollup_example> 
更多详细信息，请参见GraphiteMergeTree。
```
10. http_port/https_port：通过HTTP连接到服务器的端口。如果指定了https_port，则必须配置openSSL。如果指定了http_port，则即使已设置openSSL配置，也会将其忽略。
```
<http_port>8123</http_port>
```
11. http_server_default_response：访问ClickHouse HTTP服务器时默认显示的页面。默认值为“OK”（末尾有换行符）
```
<http_server_default_response>
  <![CDATA[<html ng-app="SMI2"><head><base href="http://ui.tabix.io/"></head><body><div ui-view="" class="content-ui"></div><script src="http://loader.tabix.io/master.js"></script></body></html>]]>
</http_server_default_response>
```
12. include_from：带替换文件的路径，有关更多信息，请参见“Configuration files”部分。
```
<include_from>/etc/metrica.xml</include_from>
```
13. interserver_http_port：于在ClickHouse服务器之间交换数据的端口。
```
<interserver_http_port>9009</interserver_http_port>
```
14. interserver_http_host：其他服务器可以用来访问该服务器的主机名。如果省略，则其定义方法与hostname -f命令相同。
```
<interserver_http_host>example.yandex.ru</interserver_http_host>
```
15. interserver_http_credentials：在使用Replicated *引擎进行复制期间进行身份验证的用户名和密码。 这些凭据仅用于副本之间的通信，与ClickHouse客户端的凭据无关。 服务器正在检查这些凭据以连接副本，并在连接到其他副本时使用相同的凭据。 因此，对于群集中的所有副本，应将这些凭据设置为相同。默认不使用身份验证。
```
<interserver_http_credentials>
    <user>admin</user>
    <password>222</password>
</interserver_http_credentials>
```
16. keep_alive_timeout：ClickHouse在关闭连接之前等待传入请求的秒数。 默认为3秒。
```
<keep_alive_timeout>3</keep_alive_timeout>
```
17. listen_host：限制来源主机的请求， 如果要服务器回答所有请求，请指定“::” ：
```
<listen_host> :: 1 </ listen_host>
<listen_host> 127.0.0.1 </ listen_host>
```
18. logger：日志记录设置。选项组里的设置有：level、log、errorlog、size、count：
```
<logger>
    <level>trace</level>  --日志记录级别。可接受的值： trace, debug, information, warning, error
    <log>/var/log/clickhouse-server/clickhouse-server.log</log> --日志文件，根据级别包含所有条目
    <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog> -- 错误日志文件
    <size>1000M</size> -- 文件的大小。适用于loganderrorlog，文件达到大小后，ClickHouse将对其进行存档并重命名，并在其位置创建一个新的日志文件
    <count>10</count>  --  ClickHouse存储的已归档日志文件的数量
</logger>
还支持写入系统日志：
<logger>
    <use_syslog>1</use_syslog>  -- 写入系统日志
    <syslog>
        <address>syslog.remote:10514</address> -- syslogd的主机[：port]。如果省略，则使用本地守护程序
        <hostname>myhost.local</hostname> -- 可选，从中发送日志的主机的名称。
        <facility>LOG_LOCAL6</facility> -- syslog关键字，其大写字母带有“ LOG_”前缀：（LOG_USER，LOG_DAEMON，LOG_LOCAL3，依此类推）
        <format>syslog</format> -- 格式。可能的值：bsd和syslog
    </syslog>
</logger>
```
19. macros：复制表的参数替换，如果不使用复制表，则可以省略。有关更多信息，请参见“Creating replicated tables”
```
<macros incl="macros" optional="true" />
```
20. mark_cache_size：标记缓存的大小，用于MergeTree系列的表中。  以字节为单位，共享服务器的缓存，并根据需要分配内存。缓存大小必须至少为5368709120（5G）。 
```
<mark_cache_size>5368709120</mark_cache_size> 
```
21. max_concurrent_queries：同时处理的最大请求数。
```
<max_concurrent_queries>100</max_concurrent_queries>
```
22. max_connections：最大连接数。
```
<max_connections>4096</max_connections>
```
23. max_open_files：打开最大的文件数，默认最大值
```
<max_open_files> 262144 </ max_open_files>
```
24. max_table_size_to_drop：删除表的限制，默认50G，0表示不限制。如果MergeTree表的大小超过max_table_size_to_drop（以字节为单位），则无法使用DROP查询将其删除。如果仍然需要删除表而不重新启动ClickHouse服务器，请创建<clickhouse-path>/flags/force_drop_table文件并运行DROP查询。
```
<max_table_size_to_drop>0</max_table_size_to_drop>
```
25. merge_tree：对MergeTree中的表进行调整，有关更多信息，请参见MergeTreeSettings.h头文件。
```
<merge_tree>
<max_suspicious_broken_parts>5</max_suspicious_broken_parts>
</merge_tree>
```
26. openSSL：SSL客户端/服务器配置。服务器/客户端设置：
```
<openSSL>
    <server>
        <!-- openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/clickhouse-server/server.key -out /etc/clickhouse-server/server.crt -->
        <certificateFile>/etc/clickhouse-server/server.crt</certificateFile> --PEM格式的客户端/服务器证书文件的路径。如果privateKeyFile包含证书，则可以忽略它。
        <privateKeyFile>/etc/clickhouse-server/server.key</privateKeyFile>   --具有PEM证书的秘密密钥的文件的路径。该文件可能同时包含密钥和证书。
        <!-- openssl dhparam -out /etc/clickhouse-server/dhparam.pem 4096 -->
        <dhParamsFile>/etc/clickhouse-server/dhparam.pem</dhParamsFile>
        <verificationMode>none</verificationMode>  --检查节点证书的方法。详细信息在Context类的描述中。可能的值：none, relaxed, strict, once.
        <loadDefaultCAFile>true</loadDefaultCAFile> --指示将使用OpenSSL的内置CA证书。可接受的值：true，false
        <cacheSessions>true</cacheSessions>  --启用或禁用缓存会话。必须与sessionIdContext结合使用。可接受的值：true，false。
        <disableProtocols>sslv2,sslv3</disableProtocols> --不允许使用的协议。
        <preferServerCiphers>true</preferServerCiphers> ----首选服务器密码
    </server>
    <client>
        <loadDefaultCAFile>true</loadDefaultCAFile>  --指示将使用OpenSSL的内置CA证书。可接受的值：true，false
        <cacheSessions>true</cacheSessions>  -- --启用或禁用缓存会话。必须与sessionIdContext结合使用。可接受的值：true，false。
        <disableProtocols>sslv2,sslv3</disableProtocols>  --不允许使用的协议。
        <preferServerCiphers>true</preferServerCiphers> --首选服务器密码
        <!-- Use for self-signed: <verificationMode>none</verificationMode> -->
        <invalidCertificateHandler>  --用于验证无效证书的类
            <!-- Use for self-signed: <name>AcceptCertificateHandler</name> -->
            <name>RejectCertificateHandler</name>
        </invalidCertificateHandler>  
    </client>
</openSSL>
```
27. part_log：记录与MergeTree关联的事件。如添加或合并数据。可以使用日志来模拟合并算法并比较其特征。 查询记录在system.part_log表中，而不记录在单独的文件中。 您可以在table参数中配置该表的名称（<part_log>）。使用以下参数来配置日志记录：
```
<part_log>
    <database>system</database>   --库名
    <table>part_log</table>  --表名
    <partition_by>toMonday(event_date)</partition_by>  --自定义分区键
    <flush_interval_milliseconds>7500</flush_interval_milliseconds> --将数据从内存中的缓冲区刷新到表的时间间隔，单位毫秒。
</part_log>
```
28. path：数据的目录路径。
```
<path>/var/lib/clickhouse/</path>
```
29. query_log：通过log_queries = 1设置，记录接收到的查询。查询记录在system.query_log表中，而不记录在单独的文件中。可以在table参数中更改表的名称。
```
<query_log>
    <database>system</database>   --库名
    <table>query_log</table>   --表名
    <partition_by>toMonday(event_date)</partition_by>  --自定义分区键
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>  --将数据从内存中的缓冲区刷新到表的时间间隔
</query_log>
如果该表不存在，ClickHouse将创建它。如果在更新ClickHouse服务器时查询日志的结构发生了更改，则具有旧结构的表将重命名，并自动创建一个新表。
```

30. query_thread_log：使用log_query_threads = 1设置，记录接收到查询的线程。查询记录在system.query_thread_log表中，而不记录在单独的文件中。您可以在table参数中更改表的名称。
```
<query_thread_log>
    <database>system</database>     --库名
    <table>query_thread_log</table>  --表名
    <partition_by>toMonday(event_date)</partition_by>  --自定义分区键
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>  --将数据从内存中的缓冲区刷新到表的时间间隔
</query_thread_log>
如果该表不存在，ClickHouse将创建它。如果在更新ClickHouse服务器时查询线程日志的结构发生了更改，则具有旧结构的表将重命名，并自动创建一个新表。
```
31. trace_log：trace_log系统表操作的设置。
```
<trace_log>
    <database>system</database>  --库名
    <table>trace_log</table>   --表名
    <partition_by>toYYYYMM(event_date)</partition_by>  ----自定义分区键
    <flush_interval_milliseconds>7500</flush_interval_milliseconds>  ----将数据从内存中的缓冲区刷新到表的时间间隔
</trace_log>
```
32. query_masking_rules：基于Regexp的规则，应用于查询以及所有日志消息。再其存储在服务器日志中，system.query_log，system.text_log，system.processes表以及以日志形式发送给客户端。这样可以防止SQL查询中的敏感数据泄漏记录到日志中。
```
<query_masking_rules>
    <rule>
        <name>hide SSN</name>   --规则名称
        <regexp>(^|\D)\d{3}-\d{2}-\d{4}($|\D)</regexp>  --正则表达式
        <replace>000-00-0000</replace>  --替换，敏感数据的替换字符串（默认为可选-六个星号）
    </rule>
</query_masking_rules>
规则适用于整个查询，system.events表具有计数器QueryMaskingRulesMatch，该计数器具有查询掩码规则匹配的总数。对于分布式查询，必须分别配置每个服务器，否则子查询将传递给其他服务器节点将被存储而不会屏蔽。
```

33. remote_servers：远程服务器，分布式表引擎和集群表功能使用的集群的配置。
```
<remote_servers incl="clickhouse_remote_servers" />
```
34. timezone：服务器的时区，定为UTC时区或地理位置（例如，非洲/阿比让）的IANA标识符。
```
当DateTime字段输出为文本格式（打印在屏幕或文件中），以及从字符串获取DateTime时，时区对于在String和DateTime格式之间进行转换是必需的。 此外，如果在输入参数中未接收到时区，则在使用时间和日期的函数中会使用时区。

<timezone>Europe/Moscow</timezone>
```
35. tcp_port：通过TCP协议与客户端进行通信的端口，即ClickHouse端口。
```
<tcp_port>9000</tcp_port>
```
36. tcp_port_secure：通过TCP协议与客户端进行通信的端口，即ClickHouse端口。 与OpenSSL设置一起使用。
```
<tcp_port_secure> 9440 </ tcp_port_secure> 
```
37. mysql_port：通过MySQL协议与客户端通信的端口。
```
<mysql_port>9004</mysql_port>
```
38. tmp_path：用于处理大型查询的临时数据的路径。
```
<tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
```
39. tmp_policy：从storage_configuration的策略，用于存储临时文件。如果未设置，则使用tmp_path，否则将忽略它。

40. uncompressed_cache_size：表引擎从MergeTree使用的未压缩数据的缓存大小（以字节为单位，8G）。服务器有一个共享缓存，内存是按需分配的。如果启用，则使用高速缓存。在个别情况下，未压缩的缓存对于非常短的查询是有利的。
```
<uncompressed_cache_size>8589934592</uncompressed_cache_size>
```
41. user_files_path：包含用户文件的目录，在表函数file()中使用。
```
<user_files_path>/var/lib/clickhouse/user_files/</user_files_path>
```
42. users_config：用户配置文件，可以配置用户访问、profiles、quota、查询等级等。
```
<users_config>users.xml</users_config>
```
43. zookeeper：ClickHouse与ZooKeeper群集进行交互的设置。使用复制表时，ClickHouse使用ZooKeeper来存储副本的元数据。如果不使用复制表，则可以忽略此参数。
```
<zookeeper>
    <node>
        <host>example1</host>
        <port>2181</port>
    </node>
    <node>
        <host>example2</host>
        <port>2181</port>
    </node>
    <session_timeout_ms>30000</session_timeout_ms>  --客户端会话的最大超时（以毫秒为单位）
    <operation_timeout_ms>10000</operation_timeout_ms>
    <!-- Optional. Chroot suffix. Should exist. -->
    <root>/path/to/zookeeper/node</root>   -- 用作ClickHouse服务器使用的znode的根的znode
    <!-- Optional. Zookeeper digest ACL string. -->
    <identity>user:password</identity>  --用户和密码，ZooKeeper可能需要这些用户和密码才能访问请求的znode
</zookeeper>
可以看复制和ZooKeeper说明。
```

44. use_minimalistic_part_header_in_zookeeper：ZooKeeper中数据部分头的存储方法。1：打开；0：关闭。默认0
```
仅适用于MergeTree系列。可以指定：

位于config.xml文件的merge_tree部分，对服务器上的所有表使用该设置。 可以随时更改设置。 当设置更改时，现有表将更改其行为。
对于每个单独的表，创建表时，请指定相应的引擎设置。 即使全局设置发生更改，具有此设置的现有表的行为也不会更改。
如果use_minimalistic_part_header_in_zookeeper = 1，则复制的表使用单个znode紧凑地存储数据部分的头。 如果表包含许多列，则此存储方法将大大减少Zookeeper中存储的数据量。但无法将ClickHouse服务器降级到不支持此设置的版本，在群集中的服务器上升级ClickHouse时要小心。 不要一次升级所有服务器。 在测试环境中或仅在群集中的几台服务器上测试ClickHouse的新版本更为安全。已经使用此设置存储的数据部件标题无法恢复为其以前的（非紧凑）表示形式。
```

45. disable_internal_dns_cache：禁用内部DNS缓存，默认0。

46. dns_cache_update_period：内部DNS缓存中存储的IP地址的更新时间（以秒为单位），更新是在单独的系统线程中异步执行的，默认15秒。

### Settings：使用set设置（system.settings）
1. distributed_product_mode：更改分布式子查询的行为。当查询包含分布式表的乘积，即当分布式表的查询包含分布式表的非GLOBAL子查询时，ClickHouse将应用此设置。

限制条件：
* 仅适用于IN和JOIN子查询。
* 仅当FROM部分使用包含多个分片的分布式表时。
* 如果子查询涉及一个包含多个分片的分布式表。
* 不用于远程功能。
* 可设置的值：
    * deny：默认值。 禁止使用这些类型的子查询（返回“ Double-distributed in / JOIN子查询被拒绝”异常）。
    * local：将子查询中的数据库和表替换为目标服务器（碎片）的本地查询，而保留普通的IN / JOIN。
    * global：用GLOBAL IN / GLOBAL JOIN替换IN / JOIN查询。
    * allow：允许使用这些类型的子查询。
2. enable_optimize_predicate_expression：SELECT查询中打开谓词下推，谓词下推可能会大大减少分布式查询的网络流量。默认1，可选0、1。 

3. fallback_to_stale_replicas_for_distributed_queries：如果没有新的数据，则强制查询到过期的副本中查询， 请参见复制。默认1，可选0、1。

4. force_index_by_date：如果无法按日期使用索引，则禁用查询执行，与MergeTree系列中的表一起使用。默认0，可选0、1。
如果force_index_by_date = 1，检查查询是否具有可用于限制数据范围的日期键条件。 如果没有合适的条件，它将引发异常。 但不会检查条件是否减少了要读取的数据量。 如条件Date！='2000-01-01'是可以接受的，即使它与表中的所有数据匹配（即，运行查询需要完全扫描）。 

5. force_primary_key：如果无法通过主键建立索引，则禁用查询执行，与MergeTree系列中的表一起使用。默认0，可选0、1。
如果force_primary_key = 1，检查查询是否具有可用于限制数据范围的主键条件。 如果没有合适的条件，它将引发异常。 但不会检查条件是否减少了要读取的数据量。

6. format_schema：使用定义的格式。

7. fsync_metadata：写入.sql文件时启用或禁用fsync。 默认1，启用。可选0、1。如果服务器具有数百万个不断创建和销毁的小表，则禁用它是有意义的。

8. enable_http_compression：HTTP请求的响应中启用或禁用数据压缩。默认0，可选0、1。

9. http_zlib_compression_level：设置HTTP请求的响应中的数据压缩级别。默认3，可选1~9。

10. http_native_compression_disable_checksumming_on_decompress：从客户端解压缩HTTP POST数据时启用或禁用校验和验证。 仅用于ClickHouse本机压缩格式（不适用于gzip或deflate），默认0，禁用，可选0、1。

11. send_progress_in_http_headers：在clickhouse-server响应中启用或禁用X-ClickHouse-Progress HTTP响应标头。默认0，可选0、1。更多信息见：HTTP 客户端

12. max_http_get_redirects：限制URL引擎表的最大HTTP GET重定向跃点数。 该设置适用于两种类型的表：由CREATE TABLE查询和url表函数创建的表。默认0，可选0、非0正整数。

13. input_format_allow_errors_num：设置从文本格式（CSV，TSV等）读取时可接受的最大错误数。默认0。如果在读取行时发生错误，但错误计数器仍小于input_format_allow_errors_num，则ClickHouse会忽略该行并继续进行下一行。如果同时超过了input_format_allow_errors_num和input_format_allow_errors_ratio，则ClickHouse会引发异常。

14. input_format_allow_errors_ratio：设置从文本格式（CSV，TSV等）读取时允许的最大错误百分比。错误百分比设置为0到1之间的浮点数。默认0。如果在读取行时发生错误，但错误计数器仍小于input_format_allow_errors_ratio，则ClickHouse会忽略该行并继续进行下一行。如果同时超过了input_format_allow_errors_num和input_format_allow_errors_ratio，则ClickHouse会引发异常。

15. input_format_values_interpret_expressions：如果快速流解析器无法解析数据，则启用或禁用完整的SQL解析器。此设置仅用于数据插入时的“值”格式。有关语法分析的更多信息，请参见“语法”部分。默认1，可选0、1：
    * 0：必须提供格式化的数据，请参阅格式部分。
    * 1：将SQL表达式用作值，但是这种方式的数据插入速度要慢得多。
如：插入具有不同设置的DateTime类型值。
    ```
    SET input_format_values_interpret_expressions = 0;
    INSERT INTO datetime_t VALUES (now())
    Exception on client:
    Code: 27. DB::Exception: Cannot parse input: expected ) before: now()): (at row 1)

    SET input_format_values_interpret_expressions = 1;
    INSERT INTO datetime_t VALUES (now())
    Ok
    ```

16. input_format_values_deduce_templates_of_expressions：启用或禁用SQL表达式模板推导。默认1。如果连续行中的表达式具有相同的结构，则可以更快地解析和解释Values中的表达式。 ClickHouse将尝试推导表达式的模板，使用该模板解析以下行，并对成功解析的行进行评估。如：
```
INSERT INTO test VALUES (lower('Hello')), (lower('world')), (lower('INSERT')), (upper('Values')), ...

1：如果input_format_values_interpret_expressions = 1和format_values_deduce_templates_of_expressions = 0会分别为每行解释表达式（这对于大量的行来说非常慢）
2：如果input_format_values_interpret_expressions = 0和format_values_deduce_templates_of_expressions = 1会使用模板lower（String）解析第一，第二和第三行。
3：如果input_format_values_interpret_expressions = 1和format_values_deduce_templates_of_expressions = 1 与前面的情况相同，但是如果无法推断出模板，则还允许回退以单独解释表达式。
```
17. input_format_values_accurate_types_of_literals： 仅当input_format_values_deduce_templates_of_expressions = 1时才使用此设置。可能会发生某些列的表达式具有相同的结构，但包含不同类型的情况，默认1，可选0、1。如：
```
(..., abs(0), ...),             -- UInt64 literal
(..., abs(3.141592654), ...),   -- Float64 literal
(..., abs(-1), ...),            -- Int64 literal
启用此设置后，ClickHouse将检查实际类型，并将使用相应类型的表达式模板。 在某些情况下，可能会大大减慢表达式的评估。禁用后，ClickHouse可能会使用更通用的类型（例如Float64或Int64而不是42的UInt64），但可能会导致溢出和精度问题。
```

18. input_format_defaults_for_omitted_fields：执行INSERT查询时，将省略的列替换为各个列的默认值。 此选项仅适用于JSONEachRow，CSV和TabSeparated格式。启用此选项后，扩展表元数据将从服务器发送到客户端。 消耗了服务器上的其他计算资源，并可能降低性能。默认1，可选0、1。

19. input_format_tsv_empty_as_default：将TSV中的空白字段替换为默认值。对于复杂的默认表达式，也必须启用input_format_defaults_for_omitted_fields。默认0，可选0、1。

20. input_format_null_as_default：如果输入数据包含NULL，但对应列的数据类型不是Nullable（T），则启用或禁用默认值（对于文本输入格式）,默认0，可选0、1

21. input_format_skip_unknown_fields：启用或禁用跳过多余数据列的插入。默认0，可选0、1。写入数据时，如果输入数据包含目标表中不存在的列，则ClickHouse会引发异常。如果启用了跳过，则ClickHouse不会插入额外的数据，也不会引发异常。支持格式：JSONEachRow,CSVWithNames,TabSeparatedWithNames,TSKV。

22. input_format_import_nested_json：启用或禁用带有嵌套对象的JSON数据插入。默认0，可选0、1。支持的格式为JSONEachRow。

23. input_format_with_names_use_header：启用或禁用在插入数据时检查列顺序。默认0，可选0、1。为了提高插入性能，如果确定输入数据的列顺序与目标表中的顺序相同，则建议禁用此检查。支持的格式CSVWithNames、TabSeparatedWithNames。

24. date_time_input_format：允许选择一个解析器的文本表示日期和时间，该设置不适用于日期和时间功能。默认basic，可选：basic、best_effort。
```
basic：lickHouse只能解析基本的YYYY-MM-DD HH：MM：SS格式。 例如，“ 2019-08-20 10:18:56”。
best_effort：启用扩展解析，可以解析基本的YYYY-MM-DD HH：MM：SS格式以及所有ISO 8601日期和时间格式，如：'2018-06-08T01:02:03.000Z'。
可以看DateTime数据类型和日期函数。
```

25. join_default_strictness：设置JOIN子句的默认严格性，默认all。可选值：

    * ALL：如果右表具有多个匹配的行，ClickHouse将从匹配的行创建笛卡尔积。 这是标准SQL的正常JOIN行为。
    * ANY：如果右表具有多个匹配的行，则仅连接找到的第一个行。 如果右表只有一个匹配行，则ANY和ALL的结果相同。
    * ASOF：用于加入不确定匹配的序列。
    * 空字符串：如果在查询中未指定ALL或ANY，则ClickHouse会引发异常。
26. join_any_take_last_row：严格更改联接操作的行为，仅适用于具有Join引擎表的JOIN操作。默认值0。
    * 0：如果右表具有多个匹配行，则仅连接找到的第一个。
    * 1：如果右表具有多个匹配行，则仅连接找到的最后一个。
    可以看JOIN子句，联接表引擎。

27. join_use_nulls：设置JOIN行为的类型，合并表时可能会出现空单元格，ClickHouse根据此设置以不同的方式填充。默认0，可选：
    * 0：空单元格用相应字段类型的默认值填充。
    * 1：JOIN的行为与标准SQL相同。 相应字段的类型将转换为Nullable，并且将空单元格填充为NULL。
28. join_any_take_last_row：更改ANY JOIN的行为。 禁用，ANY JOIN将获取找到的第一行键。 启用，如果同一键有多个行，则ANY JOIN会获取最后匹配的行。 该设置仅在联接表引擎中使用。默认1，可选0、1。

29. max_block_size：在ClickHouse中，数据由块（列部分的集合）处理。 处理每个块都有开销。 对于要从表中加载的块大小（以行数为单位），建议使用max_block_size设置。 目的是避免在多个线程中提取大量列时避免占用过多内存，并至少保留一些缓存局部性。默认：65,536（行数）。并非总是从表中加载max_block_size大小的块。 如果很明显需要检索较少的数据，则处理较小的块。

30. preferred_block_size_bytes：用于与max_block_size相同的目的，但是它通过将其调整为适合块中的行数来设置建议的块大小（以字节为单位），但块大小不能超过max_block_size行。默认值：1,000,000。 仅在从MergeTree引擎读取时有效。

31. merge_tree_min_rows_for_concurrent_read：从MergeTree引擎表的文件中读取的行数超过merge_tree_min_rows_for_concurrent_read，则ClickHouse尝试在多个线程上从该文件执行并发读取。默认163840，可选任何正整数。

32. merge_tree_min_bytes_for_concurrent_read：从MergeTree引擎表的文件读取的字节数超过了merge_tree_min_bytes_for_concurrent_read，则ClickHouse会尝试在多个线程中同时读取该文件。默认251658240，可选任何正整数。

33. merge_tree_min_rows_for_seek：在一个文件中读取的两个数据块之间的距离小于merge_tree_min_rows_for_seek行，则ClickHouse不会搜索文件，而是顺序读取数据。默认0，可选任何正整数。

34. merge_tree_min_bytes_for_seek：在一个文件中读取的两个数据块之间的距离小于merge_tree_min_bytes_for_seek字节，则ClickHouse顺序读取包含两个块的文件的范围，从而避免了额外的查找。默认0，可选任何正整数。

35. merge_tree_coarse_index_granularity：搜索数据时，ClickHouse检查索引文件中的数据标记。如果ClickHouse发现所需键在某个范围内，则会将该范围划分为merge_tree_coarse_index_granularity子范围，然后在该范围内递归搜索所需键。默认8，可选任何正偶数整数。

36. merge_tree_max_rows_to_use_cache：在一个查询中读取的行数超过merge_tree_max_rows_to_use_cache行，则它不使用未压缩块的缓存，使用压缩块的高速缓存存储为查询提取的数据。 ClickHouse使用此缓存来加快对重复的小型查询的响应。此设置可保护高速缓存免受读取大量数据的查询的破坏。 uncompressed_cache_size服务器设置定义未压缩块的缓存大小。默认1048576，可选任何正整数。

37. merge_tree_max_bytes_to_use_cache：在一个查询中读取的数据多于merge_tree_max_bytes_to_use_cache字节，则它不使用未压缩块的缓存，同上。默认2013265920，可选任何正整数。

38. min_bytes_to_use_direct_io：使用直接I/O访问存储磁盘所需的最小数据量。如果要读取的所有数据的总存储量超过min_bytes_to_use_direct_io字节，则ClickHouse会使用O_DIRECT选项从存储磁盘读取数据。默认0，禁用，可选0、正整数。

39. log_queries：设置发送到ClickHouse的查询将根据query_log服务器配置参数中的规则记录。

40. log_query_threads：设置运行的查询的线程将根据query_thread_log服务器配置参数中的规则记录。

41. max_insert_block_size：插入表中要形成的块的大小。此设置仅在服务器构成块的情况下适用。对通过HTTP接口的IN​​SERT，服务器解析数据格式并形成指定大小的块。默认1048576。默认值略大于max_block_size，这样做是因为某些表引擎（* MergeTree）在磁盘上为每个插入的块形成了一个数据部分，这是一个相当大的实体。类似地，* MergeTree表在插入期间对数据进行排序，并且足够大的块大小允许对RAM中的更多数据进行排序。

42. max_replica_delay_for_distributed_queries：以秒为单位设置时间。如果副本滞后于设置值，则不使用该副本。默认300秒，在复制表的分布式表执行SELECT时使用。

43. max_threads：查询处理线程的最大数量，不包括用于从远程服务器检索数据的线程（请参见“ max_distributed_connections”参数），适用于并行执行查询处理管道相同阶段的线程。默认值：物理CPU内核数。max_threads值越小，消耗的内存越少。
当从表中读取时，如果可以使用函数求值表达式，使用WHERE进行过滤并使用至少“max_threads”个线程数并行地为GROUP BY进行预聚合。如在服务器上运行少于一个SELECT查询，则将此参数设置为稍小于处理器核心实际数量的值。对于由于LIMIT而快速完成的查询，可以设置较低的“max_threads”。如如果每个块中都有必要的条目数，并且max_threads = 8，则将检索8个块，尽管仅读取一个块就足够了。

44. max_insert_threads：执行INSERT SELECT查询的最大线程数。默认值0，可选0、正整数。较高的值将导致较高的内存使用率。并行INSERT SELECT仅在SELECT部分​​并行执行时才有效。

45. max_compress_block_size：压缩写入表之前，未压缩数据块的最大大小，默认1048576（1 MiB）。如果减小大小，则由于高速缓存局部性，压缩率将降低，压缩和解压缩速度会略有增加，并且内存消耗也会减少。通常没有任何理由更改此设置。不要将压缩块（由字节组成的内存块）与查询处理块（表中的一组行）混淆。

46. min_compress_block_size：对于MergeTree表为了减少处理查询时的延迟，如果块的大小至少为min_compress_block_size，则在写入下一个标记时将压缩该块。默认值为65536。如果未压缩的数据小于max_compress_block_size，则块的实际大小不小于此值且不小于一个标记的数据量，通常没有任何理由更改此设置。

47. max_query_size：可以带到RAM以便与SQL解析器一起解析的查询的最大部分，默认256K。

48. Interactive_delay：检查请求执行是否已取消并发送进度的时间间隔，以微秒为单位。默认值：100000（检查取消并每秒发送10次进度）。

49. connect_timeout，receive_timeout，send_timeout：用于与客户端通信的套接字上的超时（以秒为单位），默认为10，300，300

50. cancel_http_readonly_queries_on_client_close：当客户端关闭连接而不等待响应时，取消HTTP只读查询。默认0，

51. poll_interval：将等待循环锁定指定的秒数，默认10。

52. max_distributed_connections：与远程服务器的并发连接的最大数量，用于对单个查询到单个Distributed表进行分布式处理。建议设置不小于集群中服务器数量的值，默认1024。

53. distributed_connections_pool_size：与远程服务器的并发连接的最大数量，用于对所有查询到单个Distributed表进行的分布式处理。 我们建议设置一个不小于集群中服务器数量的值。默认1024。

54. connect_timeout_with_failover_ms：如果集群定义中使用了“ shard”和“ replica”部分，则连接到分布式表引擎的远程服务器的超时时间（以毫秒为单位），默认50毫秒。

55. connections_with_failover_max_tries：分布式表引擎与每个副本的最大连接尝试次数，默认3。

56. extremes：是否计算极值（查询结果列中的最小值和最大值）。 接受0或1。默认情况下，0（禁用）。

57. use_uncompressed_cache：是否使用未压缩块的缓存。接受0或1。默认情况下，0（禁用）。
当使用大量短查询时，使用未压缩的缓存（仅适用于MergeTree系列中的表）可以有效减少延迟并增加吞吐量。建议为频繁发送简短请求的用户启用此设置。
注意uncompressed_cache_size配置参数（仅在配置文件中设置）：未压缩的缓存块的大小。默认情况下为8 GiB。未压缩的缓存将根据需要填充，并且使用最少的数据将自动删除。
对于读取一些数据量（一百万行或更多）的查询，未压缩的缓存将自动禁用，以节省真正小的查询的空间。这意味着可以始终将“ use_uncompressed_cache”设置设为1。

58. replace_running_query：使用HTTP接口时，可以传递'query_id'参数。这是用作查询标识符的任何字符串。如果此时已存在来自具有相同query_id的相同用户的查询，则行为取决于replace_running_query参数：
    * 0（默认值）：引发异常（如果已经在运行具有相同“ query_id”的查询，则不允许运行查询）。
    * 1 ：取消旧查询，然后开始运行新查询。
59. stream_flush_interval_ms：在超时或线程生成max_insert_block_size行的情况下，适用于具有流式传输的表，默认7500。值越小，将数据刷新到表中的频率越高。将该值设置得太低会导致性能下降。

60. load_balancing：指定用于分布式查询处理的副本选择算法。默认：Random。

    * Random (by default)：
    计算每个副本的错误数量。 查询发送到最少的错误副本，如果存在多个，则发送到其中任何一个。
    缺点：不考虑服务器的邻近性； 如果副本具有不同的数据，则可能获得不同的数据。

    * Nearest hostname：
    计算每个副本的错误数量。每隔5分钟，错误数量将被2整除。如果有一个副本的错误数量最少（即最近在其他副本上发生的错误），则将查询发送给它。如果有多个副本且错误的最小数量相同，则查询将以与配置文件中的服务器主机名最相似的主机名发送到副本。因此，如果存在等效的副本，则首选名称最接近的副本。
    * In order：
    具有相同数量错误的副本将以与配置中指定的顺序相同的顺序进行访问，
    * First or random：
    选择集合中的第一个副本，如果第一个副本不可用，则选择一个随机副本。 它在交叉复制拓扑设置中有效，但在其他配置中无效。
    first_or_random算法解决了in_order算法的问题。 使用in_order，如果一个副本出现故障，则下一个副本负载将加倍，而其余副本则处理通常的流量。 使用first_or_random算法时，负载在仍然可用的副本之间平均分配。
61. prefer_localhost_replica：启用或则禁用处理分布式查询时使用localhost副本。默认1，可选值0、1：
    * 1：ClickHouse始终向本地副本发送查询（如果存在）。
    * 0：ClickHouse使用load_balancing设置指定的平衡策略。
    注意：如果使用max_parallel_replicas，请禁用此设置。 

62. totals_mode：存在HAVING时以及存在max_rows_to_group_by和group_by_overflow_mode ='any'时如何计算TOTALS。

63. totals_auto_threshold：totals_mode ='auto'的阈值，

64. max_parallel_replicas：执行查询时，每个分片的最大副本数。为了保持一致性（以获取同一数据拆分的不同部分），此选项仅在设置采样键时才有效。复制延迟不受控制。

65. compile：启用查询编译。默认情况下，0（禁用）。编译仅用于查询处理管道的一部分：用于聚合的第一阶段（GROUP BY）。对于具有多个简单聚合函数的查询，可以看到最大的性能改进（在极少数情况下，速度提高了四倍）。通常，性能提升微不足道。在极少数情况下，它可能会减慢查询的执行速度。

66. min_count_to_compile：运行编译之前可能使用已编译代码块的次数。默认情况下，3。对于测试，可以将该值设置为0

67. output_format_json_quote_64bit_integers：如果该值为true，则在使用JSON * Int64和UInt64格式时（以与大多数JavaScript实现兼容），引号中会出现整数。否则，将输出不带引号的整数。

68. format_csv_delimiter：CSV数据中的分隔符。默认情况下为：， 

69. input_format_csv_unquoted_null_literal_as_null：对于CSV输入格式，启用或禁用将未引用的NULL解析为文字。

70. output_format_csv_crlf_end_of_line：在CSV中使用DOS / Windows样式行分隔符（CRLF），而不是Unix样式（LF）。

71. output_format_tsv_crlf_end_of_line：在TSV中使用DOC / Windows样式行分隔符（CRLF），而不是Unix样式（LF）。

72. insert_quorum：启用仲裁写入，写入多少个副本才算成功。默认0。insert_quorum <2，则禁用仲裁写入；insert_quorum> = 2，则启用仲裁写入。
当在insert_quorum_timeout期间将数据正确写入副本的insert_quorum时，INSERT才能成功。如果由于任何原因而成功写入的副本数量未达到insert_quorum，则认为写入失败，并将从已写入数据的所有副本中删除插入的块。读取从insert_quorum写入的数据时，可以使用select_sequential_consistency选项。查询时可用副本的数量小于insert_quorum则会报错。

73. insert_quorum_timeout：仲裁写入超时（秒），默认60s。 如果超时时间内没有写完，则将生成一个异常，并且客户端必须重复查询才能将同一块写入相同或任何其他副本。

74. select_sequential_consistency：启用或禁用SELECT查询的顺序一致性。默认0，可选0、1。启用顺序一致性后，ClickHouse允许客户端仅对insert_quorum执行的INSERT查询中的数据的副本执行SELECT查询。 如果客户端引用部分副本，则ClickHouse将生成一个异常。 SELECT查询将不包括尚未写入副本仲裁的数据。

75. max_network_bytes：限制执行查询时通过网络接收或传输的数据量（以字节为单位）。此设置适用于每个单独的查询。默认0，不限制。可选值：0、正整数。

76. max_network_bandwidth_for_user：限制数据在网络上每秒交换的速度（字节），用于单个用户执行的所有同时运行的查询。默认值：0，不限制。可选值：0、正整数。

77. max_network_bandwidth_for_all_users：限制数据在网络上每秒交换的速度（字节），用于服务器上所有同时运行的查询。默认值：0，不限制。可选值：0、正整数。

78. allow_experimental_cross_to_join_conversion：将连表的,语法重写成join on、using语法，如果设置值为0，则不会使用使用逗号的语法来处理查询，并且会引发异常。默认1。可选0、1。可以看join的使用

79. count_distinct_implementation：指定应使用哪个uniq *函数来执行COUNT（DISTINCT ...），默认uniqExact。可选值：uniq、uniqCombined、uniqCombined64、uniqHLL12、uniqExact

80. skip_unavailable_shards：启用或禁用跳过不可用的分片。如果分片的所有副本都不可用，则认为分片不可用。默认0，禁止跳过，可选值0、1。

81. optimize_skip_unused_shards：对在PREWHERE / WHERE中具有分片键条件的SELECT查询启用或禁用跳过未使用的分片（假设数据是通过分片键分发的，否则不执行任何操作）。默认0，禁止跳过。

82. force_optimize_skip_unused_shards：如果启用了optimize_skip_unused_shards(0)，并且无法跳过未使用的分片。如果无法跳过并且启用了设置，则将引发异常。默认0，禁用。可选值：0：禁用（不抛出）1：仅在表具有分片键时才禁用查询执行 2：禁用查询执行，无论为表定义了分片键如何

83. optimize_throw_if_noop：如果OPTIMIZE查询未执行合并，则启用或禁用引发异常。默认0，可选0：禁用引发异常；1：启用引发异常
默认情况下，即使未执行任何操作，OPTIMIZE也会成功返回。使用此设置可以区分这些情况，并在异常消息中获取原因。

84. distributed_replica_error_half_life：控制将分布式表中的错误快速归零的方式。如果某个副本在一段时间内不可用，累积了5个错误，并且distributed_replica_error_half_life设置为1秒，则该副本在上次错误之后3秒钟被视为正常。默认60s。

85. distributed_replica_error_cap：每个副本的错误计数都以该值为上限，从而防止单个副本累积太多错误，默认1000。

86. distributed_directory_monitor_sleep_time_ms：分布式表引擎发送数据的基本间隔。发生错误时，实际间隔将呈指数增长，默认100毫秒。

87. distributed_directory_monitor_max_sleep_time_ms：分布式表引擎发送数据的最大间隔。限制在distributed_directory_monitor_sleep_time_ms设置的间隔的指数增长。默认值：30000毫秒（30秒）。

88. distributed_directory_monitor_batch_inserts：启用/禁用批量发送插入的数据。启用批发送功能后，分布式表引擎将尝试通过一项操作发送多个插入数据文件，而不是分别发送。批发送通过更好地利用服务器和网络资源来提高群集性能。默认0，禁用，可选0、1。

89. os_thread_priority：为执行查询的线程设置优先级（nice）。当选择在每个可用CPU内核上运行的下一个线程时，OS调度程序会考虑此优先级。默认值：0，可选值：可以在[-20，19]范围内设置值。较低的值表示较高的优先级。

90. query_profiler_real_time_period_ns：查询事件探查器的实际时钟计时器的周期。实时时钟计时器计算挂钟时间。单位纳秒，默认值：1000000000纳秒（每秒），可选值：
    * 10000000（每秒100次）纳秒或更少的单个查询。
    * 1000000000（每秒一次）用于群集范围内的性能分析。
    * 0 用于关闭计时器。
91. allow_introspection_functions：启用禁用内省功能以进行查询概要分析。默认值：0，可选0(禁用)、1(启用)

92. input_format_parallel_parsing：启用数据格式的保留顺序并行解析。 仅支持TSV，TKSV，CSV和JSONEachRow格式。

93. min_chunk_bytes_for_parallel_parsing：每个线程将并行解析的最小块大小（以字节为单位），默认1M。

94. output_format_avro_codec：设置用于输出Avro文件的压缩编解码器。默认snappy或deflate，可选值：
    * null：不压缩
    * deflate：使用Deflate压缩（zlib）
    * snappy：使用Snappy压缩
95. output_format_avro_sync_interval：设置输出Avro文件的同步标记之间的最小数据大小（以字节为单位）。默认32K，可选值：32（32字节）~ 1073741824（1 GiB）

96. format_avro_schema_registry_url：设置Confluent Schema注册表URL以与AvroConfluent格式一起使用，默认空。