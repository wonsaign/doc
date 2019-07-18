### 此文档便于新手理解Elasticsearch

* Elasticsearch与关系数据库对应关系
    ```
    Relational DB -> Databases -> Tables -> Rows -> Columns
    Elasticsearch -> Indices -> Types -> Documents -> Fields
    ```
* 元数据
    * _Index索引
    > 提示：
    > 事实上，我们的数据被存储和索引在分片(shards)中，索引只是一个把一个或多个分片分组在一起的逻辑空间。然而，这只是一些内部细节——我们的程序完全不用关心分片。对于我们的程序而言，文档存储在索引(index)中。剩下的细节由Elasticsearch关心既可。
    * _Type
    > 在应用中，我们使用对象表示一些“事物”，例如一个用户、一篇博客、一个评论，或者一封邮件。每个对象都属于一个类(class)，这个类定义属性或与对象关联的数据。user类的对象可能包含姓名、性别、年龄和Email地址。
    * _Id
    > id仅仅是一个字符串，它与 _index 和 _type 组合时，就可以在Elasticsearch中唯一标识一个文档。当创建一个文档，你可以自定义 _id ，也可以让Elasticsearch帮你自动生成。
    * _Version
    > 乐观并发控制，可以在更新时指定版本，如：PUT /website/blog/1?version=1 ，当版本变换的时候返回409。
    * _Source
    > 默认情况下，Elasticsearch用JSON字符串来表示文档主体保存在_source 字段中。像其他保存的字段一样,_source字段也会在写入硬盘前压缩。

* bulk批量操作的时候不是事务性的，非原子性原则。
* 映射(mapping)机制用于进行字段类型确认，将每个字段匹配为一种确定的数据类型(string,number,booleans,date等)。
* 分析(analysis)机制用于进行全文文本(Full Text)的分词，以建立供搜索用的反向索引。
* 倒排索引

* 工作原理
  * 倒排索引
    * 不可变性，写入磁盘的倒排索引是不可变的，它有如下好处：
        * 不需要锁。如果从来不需要更新一个索引，就不必担心多个程序同时尝试修改。
        * 一旦索引被读入文件系统的缓存(译者:在内存)，它就一直在那儿，因为不会改变。只要文件系统缓存有足够的空间，大部分的读会直接访问内存而不是磁盘。这有助于性能提升。
        * 在索引的声明周期内，所有的其他缓存都可用。它们不需要在每次数据变化了都重建，因为数据不会变。
        * 写入单个大的倒排索引，可以压缩数据，较少磁盘IO和需要缓存索引的内存大小。
    * 更新：使用多个索引。不是重写整个倒排索引，而是增加额外的索引反映最近的变化。每个倒排索引都可以按顺序查询，从最老的开始，最后把结果聚合。
    * 持久化变更，借助了日志系统来进行事务式的提交。
* Lunuce中的索引，在Elasticsearch中叫分片，而Elasticsearch为了区分索引的概念，使用分片这个词，就是等于Lunece中索引。而Elasticsearch中的索引是分片的逻辑概念。

### Part Two 官方手册
* 开始
  * 探索你的集群
    * 集群健康
      * /_cat/health?v
      * /_cat/nodes?v
    * 遍历所有的Index
      * /_cat/indices?v
    * 创建Index(注意,6版本的es,一个index只能对应一个type)
      * `PUT` /indexname
    * 修正你的数据
      * 增删改略
      * 批量更新
        * `POST` /yourindex/_doc/_bulk  后跟Json串
  * 探索你的数据
    * 直接在URL上获取
    * 使用Query语言(Query DSL),支持Json请求.请求 `GET` /yourindex/_doc/`_search` {"query":{"match":{}}},`match`表示模糊查询
    * 指定返回字段 `GET` /yourindex/_doc/_search {"query":{},"_source":["param1","param2"]},其中`_source`中指定的字段即使返回的字段,类似SQL SELECT FROM field list.
    * 使用Query DSL , query:bool:must:[match1,match2] 其中match1和match2是'AND'关系. query:bool:should:[match1,match2]其中match1和match2是'OR'关系.query:bool:must_not:[match1,match2]代表'NOR'关系
    * 执行Filters,query:bool:must,filter:range:param1:gte,lte 其中param1代表参数, 类似sql中 param1 between gte and lte; `Between And`
    * 聚合查询(Group by) aggs:group_by_state:terms:filed:"param1.keyword",order:"param2":"desc" 类似SQL中的 select param1,count(*) from xxx group by param1 order param2 desc limit 10;
* API 习俗
  * 多倍的索引,目前所有的请求都是/test/_doc/1,/test1/_doc/1,/test2/_doc/1,那么现在可以使用test*/doc/1 来代替前面所有
  * 时间格式 GET /<logstash-{now/d}>/_search
  * 通用设置
    * _settings?flat_settings=true
* 文档API
  * 增删改查
  * 使用Query DSL语言删除,例如:POST /yourindex/`_delete_by_query` query:match
  * 使用Query DSL语言更新,例如:POST /yourindex/`_update_by_query` 
  * mget , 多倍获取 , 需要使用`docs` 如 GET/_mget  docs[{},{}]
  * bulk批量操作.
  * Reindex,重命名 POST _redindex {"source":{"index":"old"},"dest":{"index":"new"}}
  
  