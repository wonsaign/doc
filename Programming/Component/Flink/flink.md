### Flink

#### 应用场景

* 批量和流式任务（BI实时大屏）
* 数据仓库
  * 传统离线数据仓库（T+1）
  * 实时数据仓库（Flink）

#### Flink
* 状态管理（Sum group ）
* 基础构建：
  * 流
  * 转换
* 集群模型的角色
  * JobManager 管理者
  * TaskMageer 实际工作的Worker
* 与其他架构的区别
* DataSet和DateStream
  * 流处理，消息中间jian如kafka等
  * 批处理，文件，表，java集合
* 起始于datasource，终止于一个或多个sink
* DateStream的API
  * Map
  * FlatMap，类似于map
  * Filter
  * KeyBy（生产环境注意），类似与GroupBy
  * sum
  * max
  * min（生产环境上避免在无限流上使用聚合函数）
  * reduce
* SQL的API
  * 窗口
    * 滚动窗口
    * 滑动窗口
    * 绘画窗口
* 水印：为了解决实时数据中数据乱序问题。
* SideOutPut数据分流
* 精确一次，保证数据不会被多次消费。
  * 异步快照
  * 两段式提交
* Flink
  * 流
  * 算子
* 并行度：
  * 算子级别》环境级别》客户端级别》集群配置级别
* 监控